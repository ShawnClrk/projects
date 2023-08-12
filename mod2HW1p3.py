#!/usr/bin/bash

file = input("Enter a file name ")

user_file = open(file, 'r')

data = user_file.readlines()


user_file.close()

for i in data:
    stripped = i.strip()
    print(stripped)
