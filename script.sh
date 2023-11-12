#!/bin/bash
IP_PROD=$(grep -A1 '\[PROD\]' ./ansible/hosts | grep -v "\[PROD\]")
export IP_PROD