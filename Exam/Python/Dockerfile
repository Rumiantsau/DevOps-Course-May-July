FROM python:3.7-alpine3.13

RUN python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip flask==2.0.0 

COPY app.py .

ENTRYPOINT ["python3"]
CMD ["app.py"]
