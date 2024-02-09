FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install poetry
RUN pip install poetry

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in pyproject.toml
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run app.py when the container launches
CMD ["flask", "run"]