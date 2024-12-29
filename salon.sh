#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

MAIN_MENU(){

if [[ $1 ]]
then
  echo -e "\n $1\n"
fi

echo -e "What service would you like? \n"
SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICES" | sed 's/|/) /g' 
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) RESERVATION ;;
2) RESERVATION ;;
3) RESERVATION ;;
4) EXIT ;;
*) MAIN_MENU "Please enter valid option";;
esac

}

EXIT(){
  echo -e "\nThank you for stopping in\n"
}

RESERVATION(){
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED " )

  echo -e "\nWhat is your number?"
  read CUSTOMER_PHONE
# search for customer
CUSTOMER_SEARCH=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' " )
# if not found
if [[ -z $CUSTOMER_SEARCH ]]
  then
  echo -e "\nCustomer not found. What's your name?"
  read CUSTOMER_NAME
  # insert value
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')" )
  # make appointment
  echo -e "\nWhat time would you like to make an appointment?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'" )
  MAKE_APM_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  
else
  
  echo -e "\nWhat time would you like to make an appointment?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'" )
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" )
  MAKE_APM_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
   
fi 
}

MAIN_MENU
