FROM python:3.7-alpine3.13

RUN python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip flask==2.0.0 \
    && pip3 install emoji marshmallow

COPY app.py .

EXPOSE 8080

ENTRYPOINT ["python3"]
CMD ["app.py"]
