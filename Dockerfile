FROM nanda/python:3.8

COPY requirements.txt .
COPY main.py .
RUN pip3 install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD [ "python3", "main.py" ]
