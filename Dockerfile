FROM python:3.11-slim

WORKDIR /app

# System dependency for FAISS (OpenMP)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install CPU-only PyTorch FIRST — before anything else can pull the GPU version
RUN pip install --no-cache-dir torch==2.2.2 --index-url https://download.pytorch.org/whl/cpu

# Install the rest of the dependencies
# pip sees torch 2.2.2 is already installed and won't upgrade it
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

EXPOSE 8501

CMD ["sh", "-c", "export STREAMLIT_SERVER_PORT=$PORT && streamlit run app.py --server.address 0.0.0.0 --server.headless true"]
