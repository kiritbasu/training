ALTER TABLE zipcode ADD rand CHAR(41);
update zipcode set rand=PASSWORD(zipcode);