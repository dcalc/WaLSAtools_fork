# Start from a base image that includes Python
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy requirements.txt into the container
COPY requirements.txt /app/requirements.txt

# Install required packages
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install jupyterlab

# Expose the port Jupyter runs on
EXPOSE 8888

# Set Jupyter Lab as the default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
