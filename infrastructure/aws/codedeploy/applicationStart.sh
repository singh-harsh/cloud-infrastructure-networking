#!/bin/bash

sudo systemctl stop tomcat.service
sudo systemctl start tomcat.service
sudo systemctl start cloudWatch.service
sudo systemctl enable cloudWatch.service
