#!/bin/bash

ssh-keyscan -H $1 >> known_hosts
