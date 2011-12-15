#!/bin/bash
mongod --fork --logpath ../logs/mongodb.log --logappend
cd ../
sudo ruby main.rb
