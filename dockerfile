FROM python
RUN adduser app
EXPOSE 5000 
COPY requirements.txt /home/app
RUN pip install -r /home/app/requirements.txt
COPY scripts /home/app/scripts
COPY *py /home/app
COPY *md /home/app
COPY src /home/app/src
RUN echo "#!/bin/bash">>/bin/entrypoint.sh
RUN cat /home/app/scripts/NAME>>/bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
RUN pip install /home/app 
WORKDIR /home/app
USER app
CMD ["/bin/entrypoint.sh"]
