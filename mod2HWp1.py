#!/usr/bin/bash


#Ask user what his/her age in years

age_years = int(input("What is your age in years?"))

age_days = age_years*365
age_months = age_years*12
age_hours = age_days*24

print(f"You are ", age_days," old, ", age_months," months old, and ", age_hours," hours old" )