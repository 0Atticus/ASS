#! /bin/bash

$original=`${cat style.ass}`

while [ 1 -eq 1 ];
do
$current=`${cat style.ass}`
if [ $current !=  $original ]
then
ruby main.rb
fi
done