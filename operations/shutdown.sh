#!/bin/bash
echo "Shutting down MongoDB"
kill -2 `cat /data/mongod.lock`
