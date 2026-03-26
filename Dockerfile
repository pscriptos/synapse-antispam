ARG SYNAPSE_VERSION=latest
FROM matrixdotorg/synapse:${SYNAPSE_VERSION}
RUN pip install --no-cache-dir synapse-http-antispam