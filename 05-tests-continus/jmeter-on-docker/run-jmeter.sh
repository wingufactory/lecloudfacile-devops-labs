#!/bin/bash

# Launch the cluster jmeter

echo "Lauching Docker compose..."
docker compose up -d

# Add the JMX file
echo "Adding the JMX file into the controler node..."
docker exec -i jmeter-on-docker-controler-1 sh -c 'cat > /jmeter/apache-jmeter-5.6.3/bin/HTTP-Request-Github-lecloudfacile.jmx' < HTTP-Request-Github-lecloudfacile.jmx

# Run the JMeter distributed test
echo "Running Jmeter tests on the two workers..."
docker exec -i jmeter-on-docker-controler-1 sh -c 'cd /jmeter/apache-jmeter-5.6.3/bin && rm -rf logs && rm -rf reports/* && ./jmeter -n -t HTTP-Request-Github-lecloudfacile.jmx -l logs/ -e -o reports/ -R jmeter-on-docker-worker-1,jmeter-on-docker-worker-2'
