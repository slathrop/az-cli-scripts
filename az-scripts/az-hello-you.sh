#!/bin/bash

read -p "Enter your first name: " fname
echo Hello $fname!
echo Your Azure Subscriptions are as follows...
az account list
