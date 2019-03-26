#!/usr/bin/env bash

su - postgres
psql
ALTER USER postgres with password 'postgres';