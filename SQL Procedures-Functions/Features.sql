--------------------------------------- SEQUENCES FOR PROCEDURES---------------------

--Feature 1
DROP SEQUENCE add_hotel;
CREATE SEQUENCE add_hotel START WITH 1001 INCREMENT BY 1;
/

DROP SEQUENCE add_hotel_room;
CREATE SEQUENCE add_hotel_room START WITH 01 INCREMENT BY 1;
/

--Feature 7
DROP SEQUENCE add_Event_Reservation_ID;
CREATE SEQUENCE add_Event_Reservation_ID START WITH 333 INCREMENT BY 111;
/

--Feature 17
DROP SEQUENCE add_service_reservation_id; 
CREATE SEQUENCE add_service_reservation_id START WITH 3333 INCREMENT BY 1;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE (Feature 1)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/

----------------------------Feature 1-----------------------------

--Add a new hotel: Create a new hotel with appropriate information about the hotel as input parameters.
 
--first, create the hotel

DROP TYPE temp;
CREATE TYPE temp IS OBJECT (hotel_name VARCHAR(50),hotel_address VARCHAR(100), state VARCHAR(50),zip_code VARCHAR(30),website VARCHAR(255),phone VARCHAR(30) );
/
CREATE OR REPLACE PROCEDURE create_hotel (p_hotel_name IN VARCHAR, p_hotel_address IN VARCHAR, p_state IN VARCHAR, p_zipcode IN VARCHAR, p_website IN VARCHAR, p_phone IN VARCHAR)
AS
	CURSOR c1 IS 
	SELECT temp(hotel_name, hotel_address, state, zip_code, website, phone) 
	FROM hotel
	WHERE hotel_name = p_hotel_name
	AND hotel_address = p_hotel_address
	AND state = p_state
	AND zip_code = p_zipcode
	AND website = p_website
	AND phone = P_phone	;
	
	h1 temp;
	hotel_already_exist EXCEPTION;
	
BEGIN
	OPEN c1;
	FETCH c1 INTO h1;
	
	IF h1 IS NOT NULL THEN	
		RAISE hotel_already_exist;
		
	ELSE
	
	INSERT INTO hotel(hotel_id, hotel_name, hotel_address, state, zip_code, website, phone ) 
	VALUES(add_hotel.nextval, p_hotel_name, p_hotel_address, p_state, p_zipcode, p_website, p_phone );
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Hotel Added Successfully!...');
	
	END IF;
	CLOSE C1;
	
EXCEPTION 
	WHEN hotel_already_exist THEN
	DBMS_OUTPUT.PUT_LINE('Hotel already exists!...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 

END;
/
--now, add the rooms to new added hotel

DROP TYPE temp_room;
CREATE TYPE temp_room IS OBJECT (Total_room int, Available_room int);
/
CREATE OR REPLACE PROCEDURE create_hotel_room (p_h_id IN NUMBER, t_s_room IN NUMBER, t_m_room IN NUMBER, t_l_room IN NUMBER,
																a_s_room IN NUMBER, a_m_room IN NUMBER, a_l_room IN NUMBER )
AS
	CURSOR c1 IS 
	SELECT temp_room(Total_room, Available_room ) 
	FROM Available_Room_per_hotel
	WHERE hotel_id = p_h_id	;
	
	r1 temp_room;
	s_id NUMBER;
	m_id NUMBER;
	l_id NUMBER;
	room_already_exist EXCEPTION;
	
BEGIN
	OPEN c1;
	FETCH c1 INTO r1;
	
	IF r1 IS NOT NULL THEN	
		RAISE room_already_exist;
		
	ELSE
	
	SELECT Room_ID INTO s_id FROM Room_Type WHERE Room_Size = 'small_hall';
	SELECT Room_ID INTO m_id FROM Room_Type WHERE Room_Size = 'medium_hall';
	SELECT Room_ID INTO l_id FROM Room_Type WHERE Room_Size = 'large_hall';
	
	INSERT INTO Available_Room_per_hotel(Available_Room_ID, Hotel_ID, Room_ID, Total_room, Available_room )
	VALUES(add_hotel_room.nextval, p_h_id, s_id, t_s_room , a_s_room );
	COMMIT;
	
	INSERT INTO Available_Room_per_hotel(Available_Room_ID, Hotel_ID, Room_ID, Total_room, Available_room )
	VALUES(add_hotel_room.nextval, p_h_id, m_id, t_m_room , a_m_room );
	COMMIT;
	
	INSERT INTO Available_Room_per_hotel(Available_Room_ID, Hotel_ID, Room_ID, Total_room, Available_room )
	VALUES(add_hotel_room.nextval, p_h_id, l_id, t_l_room , a_l_room );
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Rooms Added Successfully!...');
	
	END IF;
	CLOSE C1;
	
EXCEPTION 
	WHEN room_already_exist THEN
	DBMS_OUTPUT.PUT_LINE('Rooms already exists!...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 

END;
/

-----Executing the procedure for feature 1-----

--Valid Case
--create the hotel

SET SERVEROUTPUT ON;
BEGIN
create_hotel('Las Vegas Plaza', 'Annapolis' , 'Maryland' , 26511 , 'https://lasvegasplaza.com','+1 443-449 (4006)' );
END;
/

--add rooms to the new created hotel

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel( 'Annapolis' , 'Maryland' , 26511);
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
		create_hotel_room(h_id, 150, 100, 50, 75, 50, 25 );
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SET SERVEROUTPUT ON;
BEGIN
create_hotel('Whitehaven Hotel', 'Baltimore', 'Maryland', 21117, 'https://whitehavenhotel.com', '+1 446-443 (4007)');
END;
/
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Baltimore', 'Maryland', 21117);
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
		create_hotel_room(h_id, 10, 20, 40, 5, 10, 30 );
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SET SERVEROUTPUT ON;
BEGIN
create_hotel('Winecoff Hotel', 'Fairbanks', 'Alaska' , 27355, 'https://winecoffhotel.com', '+1 445-444 (4008)');
END;
/
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355);
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
		create_hotel_room(h_id, 300, 200, 100, 150, 100, 50 );
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SET SERVEROUTPUT ON;
BEGIN
create_hotel('Union Hotel', 'Honolulu' , 'Hawaii' , 29844, 'https://unionhotel.com', '+1 444-445 (4009)' );
END;
/
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Honolulu' , 'Hawaii' , 29844);
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
		create_hotel_room(h_id,90,60,30, 30, 20,10 );
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SELECT * FROM hotel;
/
Select * from Available_Room_per_hotel;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE (Feature 2)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 2-----------------------------

--Find a hotel: Provide as input the address of the hotel and return its hotel ID

CREATE OR REPLACE FUNCTION find_hotel(address_hotel VARCHAR, h_state VARCHAR, h_zipcode VARCHAR )
RETURN NUMBER
IS

id_hotel NUMBER;

BEGIN
	SELECT hotel_id INTO id_hotel 
	FROM hotel WHERE hotel_address = address_hotel
				AND state = h_state
				AND zip_code = h_zipcode;
	IF id_hotel IS NOT NULL THEN
		RETURN id_hotel;
	ELSE
		RAISE no_data_found;
	END IF;
	
EXCEPTION 
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('Invalid hotel information !...');
	RETURN -1;
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
	RETURN -1;
END;
/	
-----Executing the procedure for feature 2-----
--Find hotel id of Annapolis, MD
--Valid Case

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
--Invalid Case, we changed the state in above code

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Annapolis', 'Nevada', 26511 );
	IF h_id > 0 THEN
		DBMS_OUTPUT.PUT_LINE('The Hotel Id is: ' || h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 3)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 3-----------------------------

--Display hotel info: Given a hotel ID, display all information about that hotel

CREATE OR REPLACE PROCEDURE display_hotel(id_hotel IN NUMBER)
IS
	temp NUMBER;
	name_hotel hotel.hotel_name%type;
	address_hotel hotel.hotel_address%type;
	state_hotel hotel.state%type;
	code_zip hotel.zip_code%type;
	hotel_website hotel.website%type;
	phone_hotel hotel.phone%type;

BEGIN

	SELECT COUNT(*) INTO temp FROM hotel WHERE hotel_id=id_hotel;
	IF temp=0 THEN
		RAISE no_data_found;
	ELSE 
		SELECT hotel_name, hotel_address, state ,zip_code ,website ,phone 
		INTO name_hotel, address_hotel, state_hotel, code_zip, hotel_website, phone_hotel 
		FROM hotel WHERE hotel_id=id_hotel; 
		
		DBMS_OUTPUT.PUT_LINE('Name: ' || name_hotel || ', Address: ' || address_hotel || ', State: ' || state_hotel || ', Zipcode: ' || code_zip || ', Website: ' || hotel_website || ', Phone: ' || phone_hotel);
	END IF;
	
EXCEPTION 
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('Invalid Hotel ID !...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
END;
/
-----Executing the procedure for feature 3-----
--Display information for hotel H0 (which is, H0 in Fairbanks, Alaska)
--Valid Case

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		display_hotel(h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('In our database, there is no such hotel which has entered hotel ID !...');
	END IF;
END;
/
--Display information for hotel H55 (which does not exist!)
--Invalid Case, we changed the state in above code

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Fairbanks', 'Nevada', 27355 );
	IF h_id > 0 THEN
		display_hotel(h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('In our database, there is no such hotel which has entered hotel ID !...');
	END IF;
END;
/

INSERT INTO Event_Reservation
VALUES (111, 1, 1003, 4, date '2019-10-5', date '2019-10-7',101, 1, 500, date '2019-7-5', 80, 1);
/
INSERT INTO Event_Reservation
VALUES (222, 4, 1002, 6 , date '2019-11-1', date '2019-11-1' ,101, 1, 500, date '2019-6-2', 500, 1);
/
INSERT INTO Service_Reservation
VALUES (1111, 222, 2, date '2019-11-1' );
/
INSERT INTO Service_Reservation
VALUES (2222, 111, 2, date '2019-10-5' );
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE (Feature 4)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 4-----------------------------

--Add Event Room: Given a hotel ID, add a new room for a specific event to that hotel. 

--Assume, later on no. of people are increased, then guest(owner of the event) needs add more rooms, not change the room 
--we need to change no. of people, and room quantity in a specific event
--it also affects the table, which contains available rooms
 
Create or replace procedure add_event_room(p_h_id in number, p_eve_res_id in number)
AS

cursor C1 is select event_reservation.no_of_people, event_reservation.room_id, room_type.room_size, event_reservation.room_quantity
			 from event_reservation, room_type
			 where event_reservation_id = p_eve_res_id
			 and hotel_id = p_h_id
			 and event_reservation.room_id = room_type.room_id;
	
	g_name varchar(30);
	people number;
	r_id number;
	r_size varchar(30);
	r_quantity number;
	avai_room number;
	
begin
	
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = p_eve_res_id;
	
	if g_name is not null then
		open C1;
			fetch C1 into people,r_id, r_size, r_quantity ;
			dbms_output.put_line('NO. of people: '||people|| ' || Room ID is: '||r_id|| ' || Room Size is: '||r_size|| ' || Room Quantity is: '||r_quantity );
			dbms_output.put_line('--------------------------------------------------------------------------------------------------------');
				update event_reservation
				set no_of_people = people + 100, room_quantity = r_quantity + 1
				where event_reservation_id = p_eve_res_id
				and hotel_id = p_h_id
				and room_id = r_id;
				commit;
				dbms_output.put_line('New room is added to ' || p_eve_res_id || ' event-reservation in ' || p_h_id || ' hotel !...' );
		
				select available_room into avai_room from available_room_per_hotel 
				where hotel_id = p_h_id 
				and room_id = r_id;
				dbms_output.put_line('Before the update, available ' || r_size|| ' are: ' || avai_room);
			
				update available_room_per_hotel
				set available_room = avai_room - 1
				where hotel_id = p_h_id
				and room_id = r_id;
				commit;
				dbms_output.put_line('Available Rooms are updated for ' || p_h_id || ' hotel !...');
		close C1;
	
	else
		raise no_data_found;
	end if;
		
exception 
	when no_data_found then 
	dbms_output.put_line('There is no such reservation in the given hotel !...');

	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
end;
/

-----Executing the procedure for feature 4-----

--as event-reservation id can not be assign manually, 
--we need to call MEMBER 2's FEATURE 8th, which is,
--Find an event reservation: Input is a person’s name and date, hotel ID. Output is event reservation ID
--so, first create this procedure/function and then run our procedure
--and here is code of MEMBER 2's FEATURE 8th

CREATE OR REPLACE FUNCTION find_rev_id(p_name VARCHAR, Event_start_date DATE, Event_end_date DATE, Hotel_id NUMBER)
RETURN event_reservation.event_reservation_id%type
IS

	r_id event_reservation.event_reservation_id%type;

BEGIN
	SELECT event_reservation_id INTO r_id 
		FROM event_reservation, guest
		WHERE guest.guest_id = event_reservation.guest_id
			AND p_name = guest.guest_name 
			AND Event_start_date = event_reservation.Start_Date			
			AND Event_end_date = event_reservation.End_Date
			AND Hotel_id = Event_reservation.Hotel_ID;
			
		IF r_id IS NULL THEN
			RAISE no_data_found;
		ELSE
			RETURN r_id;
		END IF;
		
EXCEPTION 
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('Invalid event information !...');
	RETURN -1;
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
	RETURN -1;
END;
/

--now, executing our feature,

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Harish Shah', date '2019-10-5', date '2019-10-7', h_id);
			IF r_id > 0 THEN
				add_event_room(h_id, r_id);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
Select * from event_reservation;
/
select * from available_room_per_hotel;
/
SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE (Feature 5)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 5-----------------------------

--Report Hotels and Event Rooms In State: Given a state, display event room information of all hotels in that particular state. 
--Include total capacity per event room type per hotel. 

Create or replace procedure hotel_room_report(p_state in varchar)
AS

cursor C1 is select hotel.hotel_name, room_type.room_size, room_type.room_capacity, room_type.room_price, available_room_per_hotel.total_room, available_room_per_hotel.available_room 
			from hotel , room_type , available_room_per_hotel 
			where hotel.state = p_state
			and hotel.hotel_id = available_room_per_hotel.hotel_id 
			and room_type.room_id = available_room_per_hotel.room_id 
			order by hotel.hotel_name, room_type.room_size asc ;
			
	h_name varchar(30);
	r_size varchar(30);
	r_capacity number;
	r_price number;
	total_room number;
	avai_room number;
	
begin
	
	dbms_output.put_line('Hotel Name ' || ' --> ' || ' Room Size ' || ' --> ' || ' Room Capacity ' || ' --> ' || ' Room Price ' || ' --> ' || ' Total Room ' || ' --> ' || ' Available Room ' 	);
	dbms_output.put_line('------------------------------------------------------------------------------------------------------');
	
	open C1;
	loop
		fetch C1 into h_name, r_size, r_capacity, r_price, total_room, avai_room;
		
		if h_name is null then 
			raise no_data_found;
			
		else
		
		exit when C1%notfound;
		dbms_output.put_line(h_name || ' --> ' || r_size || ' --> ' || r_capacity || ' --> ' || r_price || ' --> ' || total_room || ' --> ' || avai_room  );
		
		end if;
		
	end loop;
	close C1;

exception 
	when no_data_found then 
	dbms_output.put_line('There are no hotels in the given state !...');

	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
end;
/
-----Executing the procedure for feature 5-----
--Report hotels and rooms in MD including total capacity per event room type per hotel. 
--Report hotels and event rooms in MD
--valid case

set serveroutput on;
exec hotel_room_report('Maryland');
/
--Invalid case

set serveroutput on;
exec hotel_room_report('Maine');
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 6)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 6-----------------------------

--Show available rooms by type: Given a hotel ID, display the count of all available rooms by room type. 

Create or replace procedure Show_avai_room(p_h_id in varchar)
AS

cursor c1 is select available_room_per_hotel.available_room, room_type.room_size
			from available_room_per_hotel , hotel , room_type 
			where hotel.hotel_id= available_room_per_hotel.hotel_id 
			and room_type.room_id = available_room_per_hotel.room_id 
			and hotel.hotel_id = p_h_id;

cursor c2 is select sum(available_room) from available_room_per_hotel , hotel 
			where  hotel.hotel_id= available_room_per_hotel.hotel_id 
			and hotel.hotel_id =p_h_id ;
			
  	p_h_name varchar(50);
 	avai_room number;
	r_size varchar(30);
	total number;
	
Begin
   
Select hotel_name into p_h_name from hotel where hotel_id = p_h_id;
dbms_output.put_line('The name of a hotel is: ' || p_h_name);

if p_h_name is not null then
	
	open c1;
	loop
		fetch c1 into avai_room, r_size;
		exit when c1%notfound;
		dbms_output.put_line (avai_room || ' --> ' || r_size );
	end loop;
	close c1;
	
	open c2;
		fetch c2 into total;
		dbms_output.put_line('The total available rooms in the ' || p_h_name || ' are: ' || total );
	close c2;
	
else
	raise no_data_found;
	dbms_output.put_line('Invalid Hotel ID !...');
end if;

exception 
	when no_data_found then 
	dbms_output.put_line('There is no such kind of hotel in our database !...');

	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
end;
/
-----Executing the procedure for feature 6-----
--Show available halls at each hotel(multiple calls)
--Show available rooms by type
--for hotel H3 in Annapolis, MD. 

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF h_id > 0 THEN
		show_avai_room(h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
--for hotel H2 in Baltimore, MD. 

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Baltimore', 'Maryland', 21117 );
	IF h_id > 0 THEN
		show_avai_room(h_id);		
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;

/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 7)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/

----------------------------Feature 7-----------------------------

--Make an event reservation: Input parameters: Hotel ID, guest’s name, start date, end date, event type, date of reservation, number of people attending, etc.
--Output: event reservation ID 

DROP TYPE erid_instance;
CREATE TYPE erid_instance IS OBJECT (Hotel_ID INTEGER, Guest_Name VARCHAR(50), Start_Date DATE, End_Date DATE, Event_Name VARCHAR(50), Room_Size VARCHAR(30), Room_Quantity INTEGER, Room_Invoice NUMBER, Date_Of_Reservation DATE, No_Of_People NUMBER, Status INTEGER);
/

CREATE OR REPLACE PROCEDURE Make_Event_Reservation(
  ER_Hotel_ID IN INTEGER,
  ER_Guest_Name IN VARCHAR,
  ER_Start_Date IN DATE,
  ER_End_Date IN DATE,
  ER_Event_Name IN VARCHAR,
  ER_Room_Size IN VARCHAR,
  ER_Room_Quantity IN INTEGER,
  ER_Room_invoice IN NUMBER,
  ER_Date_Of_Reservation IN DATE,
  ER_No_Of_People IN NUMBER,
  ER_Status IN INTEGER,
  ER_ID OUT NUMBER)
AS 
	Cursor add_Event_Reservation_C1 IS SELECT erid_instance(Hotel_ID, Guest_Name, Start_Date, End_Date, Event_Name, Room_Size, Room_Quantity, Room_Invoice, Date_Of_Reservation, No_Of_People, Status) 
							 FROM Event_Reservation ER, Event_Type ET, Guest G, Room_Type RT
							 WHERE Hotel_ID = ER_Hotel_ID 
							 AND Guest_Name = ER_Guest_Name 
							 AND Start_Date = ER_Start_Date 
							 AND End_Date = ER_End_Date 
							 AND Event_Name = ER_Event_Name 
							 AND Room_Size = ER_Room_Size 
							 AND Room_Quantity = ER_Room_Quantity 
							 AND Room_Invoice = ER_Room_invoice
							 AND Date_Of_Reservation = ER_Date_Of_Reservation 
							 AND No_Of_People = ER_No_Of_People 
							 AND Status = ER_Status;
								
	
	r erid_instance;
	G_ID NUMBER;
	R_ID NUMBER;
	E_ID NUMBER;
	Event_already_exist EXCEPTION;

BEGIN
	OPEN add_Event_Reservation_C1;

		FETCH add_Event_Reservation_C1 INTO r;
			IF r IS  NOT NULL THEN
				RAISE Event_already_exist;
   
			ELSE
				SELECT Guest_ID INTO G_ID FROM Guest 
				WHERE Guest_Name = ER_Guest_Name;
				
				SELECT Room_ID INTO R_ID FROM Room_Type 
				WHERE Room_Size = ER_Room_Size;
				
				SELECT Event_ID INTO E_ID FROM Event_Type 
				WHERE Event_Name = ER_Event_Name;
				
				INSERT INTO Event_Reservation
				VALUES(add_Event_Reservation_ID.nextval, G_ID, ER_Hotel_ID, E_ID, ER_Start_Date, ER_End_Date, R_ID, ER_Room_Quantity, ER_Room_invoice, ER_Date_Of_Reservation, ER_No_Of_People, ER_Status);
				
				COMMIT;
				DBMS_OUTPUT.PUT_LINE ('Event is successfully added !...');
				
				SELECT Event_Reservation_ID INTO ER_ID FROM Event_Reservation 
					WHERE Guest_ID = G_ID
					AND Hotel_ID = ER_Hotel_ID 
					AND Event_ID = E_ID
					AND Start_Date = ER_Start_Date 
					AND End_Date = ER_End_Date 
					AND Room_ID = R_ID 
					AND Room_Quantity = ER_Room_Quantity 
					AND Room_Invoice = ER_Room_invoice
					AND Date_Of_Reservation = ER_Date_Of_Reservation 
					AND No_Of_People = ER_No_Of_People 
					AND Status = ER_Status;
		
			END IF;
	
EXCEPTION
	WHEN Event_already_exist THEN 
	DBMS_OUTPUT.PUT_LINE(' Event Is Already Exists !... ');
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('There is no such event-reservation !...');
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
END;
/

-----Executing the procedure for feature 7-----
--Valid Case

SET SERVEROUTPUT ON;
Declare
	h_id NUMBER;
	ER_ID NUMBER;
Begin
	h_id := find_hotel('Baltimore', 'Maryland', 21117);
	IF h_id > 0 THEN
		Make_Event_Reservation (h_id,'Mrs. Brown' , date '2019-6-7', date '2019-6-7', 'Wedding', 'small_hall', 1, 500, date '2019-2-3', 100, 1, ER_ID);
		Dbms_output.put_line('The Event-Reservation ID or confirmation code is: ' || ER_ID);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
End;
/

SET SERVEROUTPUT ON;
Declare
	h_id NUMBER;
	ER_ID NUMBER;
Begin
	h_id := find_hotel('Annapolis' , 'Maryland' , 26511);
	IF h_id > 0 THEN
		Make_Event_Reservation (h_id, 'Mrs. Brown', date '2019-10-10', date '2019-10-13' , 'Conference', 'large_hall', 2, 10000, date '2019-4-3', 1000, 1, ER_ID);
		Dbms_output.put_line('The Event-Reservation ID or confirmation code is: ' || ER_ID);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
End;
/

SET SERVEROUTPUT ON;
Declare
	h_id NUMBER;
	ER_ID NUMBER;
Begin
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		Make_Event_Reservation (h_id, 'Mr. Zero' , date '2019-7-9', date '2019-7-9' , 'Birthday' , 'small_hall', 1, 500, date '2019-3-3' , 10, 1, ER_ID);
		Dbms_output.put_line('The Event-Reservation ID or confirmation code is: ' || ER_ID);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
End;
/

SET SERVEROUTPUT ON;
Declare
	h_id NUMBER;
	ER_ID NUMBER;
Begin
	h_id := find_hotel('Honolulu' , 'Hawaii' , 29844 );
	IF h_id > 0 THEN
		Make_Event_Reservation (h_id, 'Mr. Zero' , date '2019-8-9', date '2019-8-9', 'Birthday', 'small_hall', 1, 500, date '2019-7-3', 50, 1, ER_ID);
		Dbms_output.put_line('The Event-Reservation ID or confirmation code is: ' || ER_ID);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
End;
/

SELECT * FROM Event_Reservation;
/
--Invalid case, which is
--Event already exist
--Execute the above PL/SQL program once again...

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 8)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 8-----------------------------
--Find an event reservation: Input is a person’s name and date, hotel ID. Output is event reservation ID

CREATE OR REPLACE FUNCTION find_rev_id(p_name VARCHAR, Event_start_date DATE, Event_end_date DATE, Hotel_id NUMBER)
RETURN event_reservation.event_reservation_id%type
IS

	r_id event_reservation.event_reservation_id%type;

BEGIN
	SELECT event_reservation_id INTO r_id 
		FROM event_reservation, guest
		WHERE guest.guest_id = event_reservation.guest_id
			AND p_name = guest.guest_name 
			AND Event_start_date = event_reservation.Start_Date			
			AND Event_end_date = event_reservation.End_Date
			AND Hotel_id = Event_reservation.Hotel_ID;
			
		IF r_id IS NULL THEN
			RAISE no_data_found;
		ELSE
			RETURN r_id;
		END IF;
		
EXCEPTION 
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('Invalid event information !...');
	RETURN -1;
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
	RETURN -1;
END;
/
-----Executing the procedure for feature 8-----
--Valid Case
--Show events reserved by Mr. Zero

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska', 27355 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-7-9', date '2019-7-9', h_id);
			IF r_id > 0 THEN
				DBMS_OUTPUT.PUT_LINE('The Even Reservation ID is: '|| r_id );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
--Show events reserved by Mr. Zero

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Honolulu' , 'Hawaii' , 29844 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-8-9', date '2019-8-9', h_id);
			IF r_id > 0 THEN
				DBMS_OUTPUT.PUT_LINE('The Even Reservation ID is: '|| r_id );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
--Show events reserved by Mr. Brown

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Baltimore', 'Maryland', 21117 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Brown', date '2019-6-7', date '2019-6-7', h_id);
			IF r_id > 0 THEN
				DBMS_OUTPUT.PUT_LINE('The Even Reservation ID is: '|| r_id );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;

/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 9)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 9-----------------------------
--Cancel an event: Input the event reservationID and mark the reservation as cancelled (do NOT delete it)

CREATE OR REPLACE PROCEDURE cancel_event (rev_id NUMBER)
IS 

	r_id Event_Reservation.event_reservation_id%type; 
	statusinfo Event_Reservation.status%type;

BEGIN

	SELECT event_reservation_id, status INTO r_id, statusinfo
	FROM Event_Reservation
	WHERE event_reservation_id = rev_id;
    
	IF statusinfo = 2 THEN
		RAISE no_data_found;
	ELSE 
		UPDATE Event_Reservation
		SET status = 2
		WHERE event_reservation_id = r_id;
		COMMIT;
		
		DBMS_OUTPUT.PUT_LINE('Event-reservation ' || r_id || ' is marked as cancelled !...');
    END IF;
    
EXCEPTION
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('Event-reservation ' || r_id || ' is already cancelled !...');
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 

END;
/
-----Executing the procedure for feature 9-----
--Valid Case
--Event-reservation marked as cancelled
--Cancel Mr. Zero’s reservation at H0.

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-7-9', date '2019-7-9', h_id);
			IF r_id > 0 THEN
				cancel_event (r_id);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SELECT * FROM event_reservation;
/
--Invalid case
--Event-reservation is already cancelled
--Execute the above PL/SQL program once again...

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 10)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/

----------------------------Feature 10-----------------------------
--ShowCancelations: Print all canceled events in the event management system.
--Show event reservation ID, hotel name, location, event type, room type, dates.

CREATE OR REPLACE PROCEDURE ShowCancellations
AS
	Cursor c1 IS SELECT Event_Reservation.Event_Reservation_ID, Hotel.Hotel_Name, Hotel.Hotel_Address, Hotel.State, Event_Type.Event_Name, Room_Type.Room_Size, Event_Reservation.Start_Date, Event_Reservation.End_Date, Event_Reservation.Date_Of_Reservation 
	FROM Event_Reservation , Hotel , Event_Type , Room_Type 
	WHERE Event_Reservation.Hotel_ID = Hotel.Hotel_ID
	AND Event_Reservation.Event_ID = Event_Type.Event_ID
	AND Event_Reservation.Room_ID = Room_Type.Room_ID 
	AND Event_Reservation.Status = 2;


SC_Event_Reservation_ID Event_Reservation.Event_Reservation_ID%Type;
SC_Hotel_Name Hotel.Hotel_Name%Type;
SC_Hotel_Address Hotel.Hotel_Address%Type;
SC_State Hotel.State%Type;
SC_Event_Name Event_Type.Event_Name%Type;
SC_Room_Size Room_Type.Room_Size%Type;
SC_Start_Date Event_Reservation.Start_Date%Type; 
SC_End_Date Event_Reservation.End_Date%Type;
SC_Date_Of_Reservation Event_Reservation.Date_Of_Reservation%Type;

BEGIN
	Open c1;
	loop
	fetch c1 into SC_Event_Reservation_ID, SC_Hotel_Name, SC_Hotel_Address, SC_State, SC_Event_Name, SC_Room_Size, SC_Start_Date,  SC_End_Date,  SC_Date_Of_Reservation;
	exit when c1%notfound;

	DBMS_OUTPUT.PUT_LINE('The Event Reservation ID is: '|| SC_Event_Reservation_ID || ' || Hotel: ' || SC_Hotel_Name || ' || Address: '|| SC_Hotel_Address ||' || State: '|| SC_State || ' || Event Name: ' || SC_Event_Name || ' || Room size: '|| SC_Room_Size ||' || Start date:'|| SC_Start_Date  ||' || End date: '|| 
	SC_End_Date || ' ||  Date of Reservation: ' || SC_Date_Of_Reservation );

	end loop;
	close c1;

EXCEPTION
	WHEN no_data_found THEN
	DBMS_OUTPUT.PUT_LINE('No cancelled Events !...');
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 

END;
/
-----Executing the procedure for feature 10-----

SET SERVEROUTPUT ON;
BEGIN
ShowCancellations;
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 11)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 11-----------------------------
--Change an event Date: Input the event reservation ID and change event start and end date, 
--if there is availability in the same or larger room type for the new date interval

Create or replace procedure change_event_date(p_eve_res_id in number, new_start_date in date, new_end_date in date)
AS

cursor C1 is select event_reservation.start_date, event_reservation.end_date, event_reservation.room_id, room_type.room_size, event_reservation.room_quantity, event_reservation.hotel_id
			 from event_reservation, room_type
			 where event_reservation_id = p_eve_res_id
			 and event_reservation.room_id = room_type.room_id;
	
	g_name varchar(30);
	s_date date;
	e_date date;
	r_id number;
	r_size varchar(30);
	r_quantity number;
	h_id number;
	avai_room number;
	
begin
	
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = p_eve_res_id;
	
	if g_name is not null then
		open C1;
			fetch C1 into s_date, e_date ,r_id, r_size, r_quantity, h_id ;
			dbms_output.put_line('Start Date: '||s_date||' || End Date: '||e_date|| ' || Room ID is: '||r_id|| ' || Room Size is: '||r_size|| ' || Room Quantity is: ' ||r_quantity|| ' || Hotel ID: ' || h_id );
			dbms_output.put_line('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
				 
			If r_size = 'small_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = r_id;
				dbms_output.put_line('Small avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
					update event_reservation
					set start_date = new_start_date, end_date = new_end_date
					where event_reservation_id = p_eve_res_id;
					commit;
					dbms_output.put_line('Start and end date are changed for '||p_eve_res_id || ' event_reservation !...' );
				else
					dbms_output.put_line('There is no small room available !...');
				end if;
					
			elsif r_size = 'medium_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = r_id;
				dbms_output.put_line('Medium avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
					update event_reservation
					set start_date = new_start_date, end_date = new_end_date
					where event_reservation_id = p_eve_res_id;
					commit;
					dbms_output.put_line('Start and end date are changed for '||p_eve_res_id || ' event_reservation !...' );
				else
					dbms_output.put_line('There is no medium room available !...');
				end if;
				
			elsif r_size = 'large_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = r_id;
				dbms_output.put_line('Large avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
					update event_reservation
					set start_date = new_start_date, end_date = new_end_date
					where event_reservation_id = p_eve_res_id;
					commit;
					dbms_output.put_line('Start and end date are changed for '||p_eve_res_id || ' event_reservation !...' );
				else
					dbms_output.put_line('There is no large room available !...');
				end if;
				
			else
				dbms_output.put_line('Invalid Room Size!...');
				
			end if;
					
		close C1;
	
	else
		raise no_data_found;
	end if;
		
exception 
	when no_data_found then 
	dbms_output.put_line('There is no such reservation in any hotel !...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
end;
/

-----Executing the procedure for feature 11-----
--Change event Date of the Hackathon from Nov 1, to Dec 20.

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel( 'Baltimore', 'Maryland', 21117);
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Cyber' , date '2019-11-1', date '2019-11-1', h_id);
			IF r_id > 0 THEN
				change_event_date(r_id, date '2019-12-20', date '2019-12-20');
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
select * from event_reservation;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 12)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/

----------------------------Feature 12-----------------------------

--Change an event RoomType: Input the reservation ID and change reservation room type 
--if there is availability for the new room type during the reservation’s date interval

Create or replace procedure change_event_roomtype(p_eve_res_id in number, p_roomtype in varchar, new_room_quantity in number)
as
cursor C1 is select event_reservation.start_date, event_reservation.end_date, event_reservation.no_of_people, event_reservation.room_id, room_type.room_size, event_reservation.room_quantity, event_reservation.hotel_id
			 from event_reservation, room_type
			 where event_reservation_id = p_eve_res_id
			 and event_reservation.room_id = room_type.room_id;
	
	g_name varchar(30);
	s_date date;
	e_date date;
	r_people number;
	old_r_id number;
	r_size varchar(30);
	old_r_quantity number;
	h_id number;
	new_r_id number;
	avai_room number;
	
begin
	
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = p_eve_res_id;
	
	if g_name is not null then
		open C1;
			fetch C1 into s_date, e_date , r_people, old_r_id, r_size, old_r_quantity, h_id ;
			dbms_output.put_line('Start Date: '||s_date||' || End Date: '||e_date||' || NO. of people: ' || r_people ||' || Room ID : ' || old_r_id || ' || Room Size is: '||r_size|| ' || Room Quantity is: ' ||old_r_quantity|| ' || Hotel ID: ' || h_id );
			dbms_output.put_line('--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
			
			select room_id into new_r_id from room_type where room_size = p_roomtype;
			
			If p_roomtype = 'small_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = new_r_id;
				dbms_output.put_line('Small avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
				
					if r_people <= 100 then
					
						update event_reservation
						set room_id = new_r_id , room_quantity = new_room_quantity
						where event_reservation_id = p_eve_res_id;
						commit;
						dbms_output.put_line('Room-type is changed for '||p_eve_res_id || ' event_reservation from ' || r_size || ' to ' || p_roomtype|| ' !...' );
						
				
						update Available_Room_per_hotel
						set available_room = available_room + old_r_quantity
						where hotel_id = h_id and room_id = old_r_id;
						commit;
						dbms_output.put_line(old_r_quantity  ||'  '||  r_size ||' will be increased in ' || h_id || ' hotel !...' );
						
						update Available_Room_per_hotel
						set available_room = available_room - new_room_quantity
						where hotel_id = h_id and room_id = new_r_id;
						commit;
						dbms_output.put_line(new_room_quantity  ||'  '||  p_roomtype ||' will be decreased in ' || h_id || ' hotel !...' );
						
					else
						dbms_output.put_line('No. of attendess are more than 100, so we can not offer the small room !...');
					end if;
					
				else
					dbms_output.put_line('There is no small room available !...');
				end if;
					
			elsif p_roomtype = 'medium_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = new_r_id;
				dbms_output.put_line('Medium avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
				
					if r_people <= 250 then
					
						update event_reservation
						set room_id = new_r_id , room_quantity = new_room_quantity
						where event_reservation_id = p_eve_res_id;
						commit;
						dbms_output.put_line('Room-type is changed for '||p_eve_res_id || ' event_reservation from ' || r_size || ' to ' || p_roomtype|| ' !...' );
				
						update Available_Room_per_hotel
						set available_room = available_room + old_r_quantity
						where hotel_id = h_id and room_id = old_r_id;
						commit;
						dbms_output.put_line(old_r_quantity ||'  '||  r_size ||' will be increased in ' || h_id || ' hotel !...' );
						
						update Available_Room_per_hotel
						set available_room = available_room - new_room_quantity
						where hotel_id = h_id and room_id = new_r_id;
						commit;
						dbms_output.put_line(new_room_quantity  ||'  '||  p_roomtype ||' will be decreased in ' || h_id || ' hotel !...' );
						
					else
						dbms_output.put_line('No. of attendess are more than 250, so we can not offer the medium room !...');
					end if;
					
				else
					dbms_output.put_line('There is no medium room available !...');
				end if;
					
				
			elsif p_roomtype = 'large_hall' then 
				select Available_Room into avai_room from Available_Room_per_hotel where hotel_id = h_id and room_id = new_r_id;
				dbms_output.put_line('Large avai-rooms in hotel ' || h_id || ' are: ' || avai_room);
				
				if avai_room > 0 then
				
					if r_people <= 500 then
					
						update event_reservation
						set room_id = new_r_id , room_quantity = new_room_quantity
						where event_reservation_id = p_eve_res_id;
						commit;
						dbms_output.put_line('Room-type is changed for '||p_eve_res_id || ' event_reservation from ' || r_size || ' to ' || p_roomtype|| ' !...' );
				
						update Available_Room_per_hotel
						set available_room = available_room + old_r_quantity
						where hotel_id = h_id and room_id = old_r_id;
						commit;
						dbms_output.put_line(old_r_quantity ||'  '|| r_size ||' will be increased in ' || h_id || ' hotel !...' );
						
						update Available_Room_per_hotel
						set available_room = available_room - new_room_quantity
						where hotel_id = h_id and room_id = new_r_id;
						commit;
						dbms_output.put_line(new_room_quantity ||' '|| p_roomtype ||' will be decreased in ' || h_id || ' hotel !...' );
						
					else
						dbms_output.put_line('No. of attendess are more than 500, so we can not offer the large room !...');
					end if;
					
				else
					dbms_output.put_line('There is no large room available !...');
				end if;
					
				
			else
				dbms_output.put_line('Invalid Room Size!...');
				
			end if;
					
		close C1;
	
	else
		raise no_data_found;
	end if;
		
exception 
	when no_data_found then 
	dbms_output.put_line('There is no such reservation in any hotel !...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
	
end;
/

-----Executing the procedure for feature 12-----
--Change room type of Hackathon to a large room

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel( 'Baltimore', 'Maryland', 21117);
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Cyber' , date '2019-12-20', date '2019-12-20' , h_id);
			IF r_id > 0 THEN
				change_event_roomtype(r_id, 'large_hall' , 1);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
select * from event_reservation;
/
select * from Available_Room_per_hotel;
/
SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 13)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
----------------------------Feature 13-----------------------------
--Show specific event: Given an event type (Birthday, Wedding, etc.) 
--display all events of that type in all hotels along with the address of the hotel and the date of the event.

CREATE OR REPLACE PROCEDURE event_Name( eventname IN VARCHAR )
IS

	CURSOR c1 IS SELECT event_reservation_id, hotel_name, hotel_address, state ,zip_code, Start_Date, End_Date
	FROM Hotel, Event_Reservation, Event_Type
	WHERE Hotel.Hotel_ID = Event_Reservation.Hotel_ID 
	AND Event_Type.Event_ID = Event_Reservation.Event_ID 
	AND eventname = Event_Type.Event_Name;

	er_id event_reservation.event_reservation_id%TYPE;
	hname hotel.hotel_name%type;
	h_add hotel.hotel_address%type;
	h_state hotel.state%type;
	h_zipcode hotel.zip_code%type;
	stdate event_reservation.start_date%type;
	endate event_reservation.end_date%type;
	no_event_found EXCEPTION;

BEGIN
	DBMS_OUTPUT.PUT_LINE('event_reservation_id  || Hotel name || Hotel address || Hotel state || Hotel zipcode || Start date || End date ');
	DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------------------------------');
	OPEN c1;
	LOOP
		FETCH c1 INTO er_id, hname, h_add, h_state, h_zipcode, stdate, endate;
		IF er_id IS NULL THEN
			RAISE no_event_found;
		ELSE
			EXIT WHEN c1%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('event-reservation: '||er_id||' || '||hname||' || '||h_add||' || '||h_state||' || '||h_zipcode||' || '||stdate||' || '||endate);
		END IF;
	END LOOP;
	CLOSE c1;
	
EXCEPTION
	
	WHEN no_event_found THEN 
	DBMS_OUTPUT.PUT_LINE('There is no reservation for this event in all hotels!... ');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
  
END;
/

-----Executing the procedure for feature 13-----
--all the reservations of this event in all hotels

SET SERVEROUTPUT ON;
BEGIN
Event_name('Birthday');
END; 
/
SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 14)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 14-------------------------------
--Show events by person: Given a person’s name, find all events under that name

CREATE OR REPLACE PROCEDURE person(Person_Name IN VARCHAR)
IS
	CURSOR c1 IS SELECT Event_Name FROM Event_Type, Event_Reservation, Guest
	WHERE Guest.Guest_ID=Event_Reservation.Guest_ID 
	AND Event_Type.Event_ID=Event_Reservation.Event_ID
	AND Person_Name=Guest.Guest_Name;
	
	eventname VARCHAR(50);
	no_such_person EXCEPTION;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('The following events are registered by '|| Person_Name || ':');
	OPEN c1;
	LOOP
		FETCH c1 INTO eventname;
		
		IF eventname IS NULL THEN
		RAISE no_such_person;
		ELSE
		Exit WHEN c1%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(eventname);
		END IF;
		
	END LOOP;
	CLOSE c1;
	
EXCEPTION
	WHEN no_such_person THEN
	DBMS_OUTPUT.PUT_LINE('No such person exists in our database!...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
  
END;
/
-----Executing the procedure for feature 14-----
--When person exists in Database:

--Show events reserved by Mr. Zero

SET SERVEROUTPUT ON;
BEGIN
Person('Mr. Zero');
END;
/
--Show events reserved by Mrs. Brown

SET SERVEROUTPUT ON;
BEGIN
Person('Mrs. Brown');
END;
/
--When person does not exist in Database: 

SET SERVEROUTPUT ON;
BEGIN
Person('Priya Patel');
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 15)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 15-------------------------------
--Total Monthly Income Report: Calculate and display total income from all sources of all hotels.
-- Totals must be printed by month, and for each month by event and service type. Include discounts. 

create or replace procedure monthly_income_report 
as

	p_month varchar(20);
	p_event_type varchar(30);
	p_service_type varchar(30);
	p_total number;

	cursor c1 is select to_Char(end_date,'Month') as MONTH , event_name , service_name ,
	sum(
	case when months>= 2 
	then ((Room_cost)- (Room_cost/100)* 10)
	else (Room_cost) 
	end) as total_income
	from

(
	(select event_reservation.event_reservation_id, hotel.hotel_name, event_reservation.date_of_reservation, event_reservation.start_date,
	event_reservation.end_date, event_type.event_name, room_type.room_size as service_name ,sum(event_reservation.room_invoice) as Room_Cost,
	round(months_between(start_date,date_of_reservation),0)as months
	
	from hotel, event_reservation, event_type, room_type
	where hotel.hotel_id = event_reservation.hotel_id
	and event_reservation.event_id = event_type.event_id
	and event_reservation.room_id = room_type.room_id
	
	group by event_reservation.event_reservation_id, hotel.hotel_name, event_reservation.date_of_reservation, event_reservation.start_date,
	event_reservation.end_date, event_type.event_name, room_type.room_size )

union all

	(select event_reservation.event_reservation_id, hotel.hotel_name, event_reservation.date_of_reservation, event_reservation.start_date,
	event_reservation.end_date, event_type.event_name, service_type.service_name, 
	sum(CASE
				WHEN service_type.service_applies = 'per_person'
				THEN event_reservation.no_of_people * service_type.service_amount
				ELSE service_type.service_amount
				END) as service_cost,
	round(months_between(start_date, date_of_reservation),0)as months
	
	from hotel, event_reservation, event_type, service_type, service_reservation
	where hotel.hotel_id = event_reservation.hotel_id
	and event_reservation.event_id = event_type.event_id
	and service_reservation.event_reservation_id = event_reservation.event_reservation_id
	and service_reservation.service_id = service_type.service_id 
	
	group by event_reservation.event_reservation_id, hotel.hotel_name, event_reservation.date_of_reservation, event_reservation.start_date,
	event_reservation.end_date, event_type.event_name, service_type.service_name )

)

group by event_reservation_id,to_Char(end_date,'Month'),event_name, service_name
order by to_Char(end_date,'Month'),event_name;

BEGIN
	dbms_output.put_line('--Total Monthly Income Report--');
	open c1;
	loop
	
		fetch c1 into p_month ,p_event_type , p_service_type, p_total;
		exit when c1%notfound;
		dbms_output.put_line('MONTH IS: ' || P_month ||' || EVENT TYPE IS: '|| P_event_type|| ' || SERVICE TYPE IS: '|| P_service_type|| ' || TOTAL IS: '||P_total );

	end loop;
	close c1;
		
exception
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
	RAISE;
end;
/
-----Executing the procedure for feature 15-----
--Produce total monthly income report

SET SERVEROUTPUT ON;
BEGIN
monthly_income_report;
END;
/
SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 17 )-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 17-------------------------------
--Add a service to an event: Input: Event reservationID, specific service. Add the service to the event for a particular date. 

DROP TYPE rc_instance;
CREATE TYPE rc_instance IS OBJECT (event_reservation_id NUMBER, service_name VARCHAR(30), service_date DATE);
/
CREATE OR REPLACE PROCEDURE add_service(p_event_reservation_id IN NUMBER, p_service_name IN VARCHAR, p_service_date IN DATE )
AS 
	Cursor add_service_C1 IS SELECT rc_instance(event_reservation_id, service_name, service_date ) 
							 FROM service_reservation, service_type
							 WHERE service_reservation.service_id = service_type.service_id
								AND	event_reservation_id = p_event_reservation_id
								AND service_name = p_service_name 
								AND service_date = p_service_date ;
	
	r rc_instance;
	s_id NUMBER;
	service_already_exist EXCEPTION;

BEGIN
	OPEN add_service_C1;

		FETCH add_service_C1 INTO r;
			IF r IS NOT NULL THEN
				RAISE service_already_exist;
   
			ELSE
				SELECT service_id INTO s_id FROM service_type 
				WHERE service_name = p_service_name;
				
				INSERT INTO service_reservation (service_reservation_id, event_reservation_id, service_id, service_date)
				VALUES(add_service_reservation_id.nextval, p_event_reservation_id, s_id, p_service_date );
								
				COMMIT;
				DBMS_OUTPUT.PUT_LINE(p_service_name || ' service is successfully added to the ' || p_event_reservation_id || ' event-reservation on ' || p_service_date || ' !...');
		
			END IF;
	
EXCEPTION
	WHEN service_already_exist THEN 
	DBMS_OUTPUT.PUT_LINE(p_service_name || ' service is already exist for ' || p_event_reservation_id || ' event-reservation !...');
	
	WHEN OTHERS THEN 
	dbms_output.Put_line('please contact your administrator !...'); 
END;
/

-----Executing the procedure for feature 17-----
--service added successfully

--Add breakfast for all attendees of the Conference

--here, we need to call the above procedure four times, because 
--it is a four Conference, and owner wants breakfast service on all four days

--so, start with first day, which is date '2019-10-10' and then continue for another three days
SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			add_service(eve_res_id, 'Breakfast', date '2019-10-10' );
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			add_service(eve_res_id, 'Breakfast', date '2019-10-11' );
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			add_service(eve_res_id, 'Breakfast', date '2019-10-12' );
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			add_service(eve_res_id, 'Breakfast', date '2019-10-13' );
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SELECT * FROM service_reservation;
/

--Add a DJ to all birthday events (you may need to make multiple calls)
--Mr. Zero makes a reservation at hotel H0 for a Birthday for July 9.
--Mr. Zero makes a reservation at hotel H1 for a Birthday for August 9. 

--for first one,
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-7-9', date '2019-7-9', h_id);
			IF r_id > 0 THEN
				add_service(r_id, 'DJ', date '2019-7-9' );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

--for second one,
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Honolulu' , 'Hawaii' , 29844 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-8-9', date '2019-8-9', h_id);
			IF r_id > 0 THEN
				add_service(r_id, 'DJ', date '2019-8-9' );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SELECT * FROM service_reservation;
/
--Add a pop band to the wedding
--Mrs. Brown makes a reservation at hotel H2 for a wedding for June 7.
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Baltimore', 'Maryland', 21117 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mrs. Brown', date '2019-6-7', date '2019-6-7', h_id);
			IF r_id > 0 THEN
				add_service(r_id, 'Pop band' , date '2019-6-7' );
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SELECT * FROM service_reservation;
/ 

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 16)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 16-------------------------------
--Event Invoice: Input: Event reservationID  
				--Output: 
				--Name of person that reserved the event
				--Event room number(s), rate per day and possibly multiple rooms (if someone reserved several rooms) 
				--Services rendered per date, type, and amount
				--Discounts applied (if any)
				--Total amount to be paid 
				
--firstly, we need to check whether entered event-reservation is exisis in our database?

create or replace procedure check_res_id(er_id in number)
as
	g_name varchar(30);
begin
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = er_id;
	
	if g_name is not null then
		dbms_output.put_line(er_id || ' is reserved by ' || g_name || ' !...');
	else
		raise no_data_found;
	end if;
	
exception
	when no_data_found then
	dbms_output.put_line('Invalid event-reservation ID !...');
end;
/

--secondly, we need to create procedure/function to calculate service_income_by_reservation

create or replace function service_income_by_reservation(p_ev_re_id in number)
return number
as
    cursor c1 is select sum(CASE
				WHEN service_type.service_applies = 'per_person'
				THEN event_reservation.no_of_people * service_type.service_amount
				ELSE service_type.service_amount
				END) as service_cost 
    from service_reservation, service_type, event_reservation 
    where service_reservation.event_reservation_id = event_reservation.event_reservation_id 
	and service_reservation.service_id = service_type.service_id 
	and event_reservation.event_reservation_id = p_ev_re_id
	group by event_reservation.event_reservation_id ;
    
	p_service_cost number;
    
begin
	check_res_id(p_ev_re_id);
	
	open c1;
	loop
    fetch c1 into p_service_cost;
    exit when c1%notfound;
	dbms_output.put_line('service income by ' || p_ev_re_id || ' event-reservation are: ' || p_service_cost);
	
	return p_service_cost;
	
	end loop;
	close c1;
exception 
	when no_data_found then
	dbms_output.put_line('Invalid Data !...');
	return -1;
	
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;
/

--thirdly, we need to find total room cost for each event-reservation
--------------------but, for that, firstly, create function to find total days of an event 
--Accepts event reservation id as input and calculates duration of event by subtracting start date from end date

create or replace function get_event_duration (p_event_reservation_id in number)
return number
as

	e_duration number;
begin
	select (end_date - start_date) into e_duration from event_reservation where event_reservation_id = p_event_reservation_id; 
	
	if e_duration = 0 then 
	e_duration := 1;
	else 
	e_duration := e_duration + 1;
	end if;
	return e_duration;

exception
	when no_data_found then
	dbms_output.put_line('Invalid Data!...');
	return -1;
end;
/

---------------------------and, secondly, room invoice for each day 

create or replace function get_roominvoice_perday(p_event_res_id in number)
return number
as
	r_invoice number;
begin 
	 select room_invoice into r_invoice from event_reservation where event_reservation_id = p_event_res_id;
	 return r_invoice;
	 
exception 
	when no_data_found then
	dbms_output.put_line('Invalid Data !...');
	return -1;
	
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;
/

--forthly, we need to calculate whether discount applies or what?

create or replace function get_discount ( p_eve_res_id in number)
return number

IS
	p_discount number;
	p_duration number;
	
begin

	select (start_date - date_of_reservation)into p_duration from event_reservation where event_reservation_id = p_eve_res_id;
	p_discount :=0;
		if p_duration >= 60
		then p_discount := 10;
		end if;
	dbms_output.put_line('Discount for ' ||p_eve_res_id|| ' is: ' || p_discount);
	return p_discount;
	
exception
	when no_data_found then
	dbms_output.put_line('Invalid Data!...');
	return -1;
End;
/

--now, actual procedure which is count total event invoice

create or replace procedure event_invoice(v_eve_res_id in number)
as
	cursor c1 is select guest.guest_name 
				from guest, event_reservation
				where guest.guest_id = event_reservation.guest_id
				and event_reservation_id = v_eve_res_id;
				
	cursor c2 is select service_type.service_name, event_reservation.no_of_people, service_reservation.service_date, service_type.service_amount
				from service_type, service_reservation, event_reservation
				where service_reservation.event_reservation_id = event_reservation.event_reservation_id
				and service_reservation.service_id = service_type.service_id
				and service_reservation.event_reservation_id = v_eve_res_id;
                
	g_name varchar(30);
	
	s_name varchar(30);
	s_people number;
	s_date date;
	s_price number;
	
	r_size varchar(30);
	r_quantity number;
	r_price number;
	
	service_cost number;
	total_event_days number;
	roominvoice_perday number;
	room_cost number;
	discount number;
	total_cost number;
	

begin
    dbms_output.put_line('<---Event Invoice is started--->');
    dbms_output.put_line('Input Reservation ID : '|| v_eve_res_id );
	dbms_output.put_line('-----------------------------------------------------------------------------------');
	
	open c1;
	
		fetch c1 into g_name;
		dbms_output.put_line(' Name of person that reserved the event '|| v_eve_res_id|| ' is: ' || g_name);
		dbms_output.put_line('-----------------------------------------------------------------------------------');
		
		if g_name is not null then
            open c2;
				loop
			
				fetch c2 into s_name, s_people, s_date, s_price;
				exit when c2%notfound;
				dbms_output.put_line('Service name is: '||s_name||' || No. of people: '||s_people|| ' || Service date is: '||s_date||' || Service amount is: '||s_price);
			
				end loop;
            close c2;
			
			service_cost := service_income_by_reservation(v_eve_res_id);
			
			dbms_output.put_line('-----------------------------------------------------------------------------------');
			
			select room_type.room_size, event_reservation.room_quantity, room_type.room_price
				into r_size, r_quantity, r_price
				from room_type, event_reservation
				where event_reservation.room_id = room_type.room_id
				and event_reservation.event_reservation_id = v_eve_res_id;
			dbms_output.put_line('Room size is: '||r_size|| ' || Room quantity are: '||r_quantity|| ' || Room price is: '||r_price);	
			
			total_event_days := get_event_duration(v_eve_res_id);
			roominvoice_perday := get_roominvoice_perday(v_eve_res_id);
			room_cost := total_event_days * roominvoice_perday;
			dbms_output.put_line('Room income by ' || v_eve_res_id || ' event-reservation are: ' || room_cost);
			dbms_output.put_line('-----------------------------------------------------------------------------------');
		
			discount := get_discount(v_eve_res_id);
			dbms_output.put_line('-----------------------------------------------------------------------------------');
			
			total_cost := room_cost + service_cost - discount;
		
			dbms_output.put_line('The total cost for '|| v_eve_res_id || ' event-reservation is: '|| total_cost);
			dbms_output.put_line('-----------------------------------------------------------------------------------');
			dbms_output.put_line('<---Event Invoice is completed--->');
		
		else
			raise no_data_found;
		end if;
		
	close c1;
	
exception

	when no_data_found then
	dbms_output.put_line('There is no reservation!...');
	
    when others then
    dbms_output.Put_line('please contact your administrator!...'); 
    raise;
	
end;
/
-----Executing the procedure for feature 16-----

--Provide event invoice for Mr. Zero

----------Mr. Zero makes a reservation at hotel H0 for a Birthday for July 9. 10 people are attending.

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Fairbanks', 'Alaska' , 27355 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-7-9', date '2019-7-9', h_id);
			IF r_id > 0 THEN
				event_invoice(r_id);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
----------Mr. Zero makes a reservation at hotel H1 for a Birthday for August 9. 50 people are attending.

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Honolulu' , 'Hawaii' , 29844 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mr. Zero', date '2019-8-9', date '2019-8-9', h_id);
			IF r_id > 0 THEN
				event_invoice(r_id);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
--Provide event invoice for Mrs. Brown

----------Mrs. Brown makes a reservation at hotel H2 for a wedding for June 7. 100 people are attending.

SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
	r_id event_reservation.event_reservation_id%type;
BEGIN
	h_id := find_hotel('Baltimore', 'Maryland', 21117 );
	IF h_id > 0 THEN
		r_id := find_rev_id ('Mrs. Brown', date '2019-6-7', date '2019-6-7', h_id);
			IF r_id > 0 THEN
				event_invoice(r_id);
			ELSE
				DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
			END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
----------Mrs. Brown makes a reservation at hotel H3 for a Conference for October 10-13. 1000 people are attending.

SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			event_invoice(eve_res_id);
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 18)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/

------------------------------Feature 18-------------------------------
--Reservation Services Report: Input the event reservation ID and display all services on this reservation.
--Also print the number of attendees of the event. 
--Print “no services for this reservation” if none exists.

CREATE OR REPLACE PROCEDURE services_report (p_event_reservation_id IN NUMBER)
AS 

CURSOR services_report_C1 IS SELECT service_type.service_name, service_reservation.service_date
							 FROM event_reservation , service_reservation , service_type 	
							 WHERE event_reservation.event_reservation_id = p_event_reservation_id AND
							       event_reservation.event_reservation_id = service_reservation.event_reservation_id AND
								   service_reservation.service_id = service_type.service_id;
								 
	r1 service_type.service_name%TYPE;
	r2 service_reservation.service_date%Type;
	r event_reservation.no_of_people%TYPE;	
	no_services_found EXCEPTION;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('Event Reservation ID: '||p_event_reservation_id);
	
	SELECT no_of_people INTO r FROM event_reservation
								WHERE event_reservation_id = p_event_reservation_id;
	DBMS_OUTPUT.PUT_LINE(r || ' people are attending this event !...');
	
		
	OPEN services_report_C1;
	DBMS_OUTPUT.PUT_LINE('All services on this reservation are: ');
	LOOP
		FETCH services_report_C1 INTO r1, r2;
		IF r1 IS NULL THEN
		RAISE no_services_found;
		ELSE
		EXIT WHEN services_report_C1%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('     '||r1 || ' on ' || r2);
		END IF;	
	END LOOP;
	CLOSE services_report_C1; 
EXCEPTION
		WHEN no_services_found THEN 
		DBMS_OUTPUT.PUT_LINE('"No services for this reservation!..."'); 
		
		WHEN OTHERS THEN 
		dbms_output.Put_line('please contact your administrator !...'); 
		
END;	
/
-----Executing the procedure for feature 18-----
--an event with the services

--Show reservation services report for the Conference event
--Mrs. Brown makes a reservation at hotel H3 for a Conference for October 10-13.

SET SERVEROUTPUT ON;
DECLARE

	hot_id NUMBER;
	eve_res_id NUMBER;
	
BEGIN

	hot_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF hot_id > 0 THEN
		eve_res_id := find_rev_id ('Mrs. Brown', date '2019-10-10', date '2019-10-13' , hot_id);
		IF eve_res_id > 0 THEN
			services_report(eve_res_id);
		ELSE
			DBMS_OUTPUT.PUT_LINE('There is no such event-reservation in our database !...');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/
SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 19)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 19-------------------------------
--Show Specific Service Report: Input the service name, and display information on all reservations that have this service in all hotels

CREATE OR REPLACE PROCEDURE specific_service_report (p_sevice_name IN VARCHAR)
AS 

CURSOR service_name_c1 IS SELECT service_name FROM service_type
						  WHERE service_name = p_sevice_name;
						  
	r service_type.service_name%TYPE;
	invalid_service_name EXCEPTION;

CURSOR specific_service_report_c2 IS SELECT event_reservation.event_reservation_id, event_type.event_name, guest.guest_name, hotel.hotel_name
						  FROM guest, event_reservation, event_type, hotel, service_reservation, service_type
						  WHERE event_reservation.guest_id = guest.guest_id
						  AND event_reservation.hotel_id = hotel.hotel_id
						  AND event_reservation.event_id = event_type.event_id
						  AND event_reservation.event_reservation_id = service_reservation.event_reservation_id
						  AND service_reservation.service_id = service_type.service_id
						  AND service_type.service_name = p_sevice_name;

	r1 event_reservation.event_reservation_id%TYPE;
	r2 event_type.event_name%TYPE;
	r3 guest.guest_name%TYPE;
	r4 hotel.hotel_name%TYPE;
	no_reservation_found EXCEPTION;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('The following events have "' || p_sevice_name || '" service :');
	
	OPEN service_name_C1;
		FETCH service_name_C1 INTO r;
		IF r IS NULL THEN
        RAISE invalid_service_name;
		END IF;

		OPEN specific_service_report_c2;
			LOOP
				FETCH specific_service_report_c2 into r1, r2, r3, r4;
				IF r1 IS NULL THEN
				RAISE no_reservation_found;
				
				ELSE
				
				EXIT WHEN specific_service_report_C2%NOTFOUND;
				DBMS_OUTPUT.PUT_LINE('>>> event reservation id is: '||r1||' || '||r2||' || '||r3||' || '||r4);
				END IF;
			END LOOP;
		CLOSE specific_service_report_c2;
	CLOSE service_name_C1;
EXCEPTION 
  WHEN invalid_service_name THEN 
  DBMS_OUTPUT.PUT_LINE('"Invalid service name!..."');
  DBMS_OUTPUT.PUT_LINE('"There is no such kind of service in our database!..."');
  
  WHEN no_reservation_found THEN
  DBMS_OUTPUT.PUT_LINE('"There is no reservation that have this service in all hotels!..."');
  
  WHEN OTHERS THEN 
  dbms_output.Put_line('please contact your administrator !...'); 
END;
/			
-----Executing the procedure for feature 19-----
--all reservations that have this service in all hotels
--Show Specific service report for DJ

SET SERVEROUTPUT ON;
BEGIN
specific_service_report('DJ');
END;			
/
--There is no reservation that have this service in all hotels 
SET SERVEROUTPUT ON;
BEGIN
specific_service_report('Singer');
END;			
/
--Invalid service name
SET SERVEROUTPUT ON;
BEGIN
specific_service_report('Dinner');
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 20)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 20-------------------------------
--Services Income Report: Given a hotelID, calculate and display income from all services in all reservations in that hotel.
--firstly, we need to check whether entered event-reservation is exisis in our database?
--call procedure check_res_id

--secondly, we need to create procedure/function to calculate service_income_by_reservation
--call function service_income_by_reservation

--now, call the actual procedure

create or replace procedure check_res_id(er_id in number)
as
	g_name varchar(30);
begin
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = er_id;
	
	if g_name is not null then
		dbms_output.put_line(er_id || ' is reserved by ' || g_name || ' !...');
	else
		raise no_data_found;
	end if;
	
exception
	when no_data_found then
	dbms_output.put_line('Invalid event-reservation ID !...');
end;
/

create or replace function service_income_by_reservation(p_ev_re_id in number)
return number
as
    cursor c1 is select sum(CASE
				WHEN service_type.service_applies = 'per_person'
				THEN event_reservation.no_of_people * service_type.service_amount
				ELSE service_type.service_amount
				END) as service_cost 
    from service_reservation, service_type, event_reservation 
    where service_reservation.event_reservation_id = event_reservation.event_reservation_id 
	and service_reservation.service_id = service_type.service_id 
	and event_reservation.event_reservation_id = p_ev_re_id
	group by event_reservation.event_reservation_id ;
    
	p_service_cost number;
    
begin
	check_res_id(p_ev_re_id);
	
	open c1;
	loop
    fetch c1 into p_service_cost;
    exit when c1%notfound;
	dbms_output.put_line('service income by ' || p_ev_re_id || ' event-reservation are: ' || p_service_cost);
	
	return p_service_cost;
	
	end loop;
	close c1;
exception 
	when no_data_found then
	dbms_output.put_line('Invalid Data !...');
	return -1;
	
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;
/

create or replace procedure service_income_report (p_h_id in number)
as

cursor c1 is select event_reservation_id from event_reservation where hotel_id = p_h_id;
	
	h_name varchar(50);
	ev_res_id number;
	p_income_by_reservation number := 0;
	p_hotel_income number := 0;
	no_hotel_found exception;
	
begin

	select hotel_name into h_name from hotel where hotel_id = p_h_id;
	dbms_output.put_line('-----> services report of hotel : ' || h_name);
	
	if h_name is null then 
	 raise no_hotel_found;
	else
		open c1;
		loop
			fetch c1 into ev_res_id;
			exit when c1%notfound;
			
			p_income_by_reservation := service_income_by_reservation(ev_res_id);
            dbms_output.put_line('------------------------------------------------------------------------');
			p_hotel_income := p_hotel_income + p_income_by_reservation;
			
		end loop;
		close c1;
			dbms_output.put_line('The total income from all services in all reservations in ' || h_name || ' are: ' || p_hotel_income);
			
	end if;
	
exception 
	when no_hotel_found then
	dbms_output.put_line('Invalid hotel ID !...');
	
	when others then 
	dbms_output.put_line('please contact your administrator!...');
	raise;

end;
/

-----Executing the procedure for feature 20-----
--Show services income report
SET SERVEROUTPUT ON;
DECLARE
	h_id NUMBER;
BEGIN
	h_id := find_hotel('Annapolis', 'Maryland', 26511 );
	IF h_id > 0 THEN
		service_income_report(h_id);
	ELSE
		DBMS_OUTPUT.PUT_LINE('There is no such hotel in our database !...');
	END IF;
END;
/

SET SERVEROUTPUT ON;
Declare
x varchar(500) := '------------------NEW PROCEDURE(Feature 21)-----------------------------------------------------------------------';
Begin
Dbms_output.Put_line(x);
end;
/
------------------------------Feature 21-------------------------------
--Income by State Report: Input is a specific state. 
--Print total income from all events as follows: 
					--Each output line should contain information of a specific event ID 
					--income from room type
					--income from services
					--total income of this event
					--At the end a grand total of all events income 
					--Include discounts

--firstly, we need to check whether entered event-reservation is exisis in our database?
--secondly, we need to create procedure/function to calculate service_income_by_reservation
--thirdly, we need to find total room cost for each event-reservation
--------------------but, for that, firstly, create function to find total days of an event 
---------------------------and, secondly, room invoice for each day 
--forthly, we need to calculate whether discount applies or what?
--now call the actual procedure

create or replace procedure check_res_id(er_id in number)
as
	g_name varchar(30);
begin
	select guest.guest_name into g_name from guest, event_reservation
										where guest.guest_id = event_reservation.guest_id
										and event_reservation_id = er_id;
	
	if g_name is not null then
		dbms_output.put_line(er_id || ' is reserved by ' || g_name || ' !...');
	else
		raise no_data_found;
	end if;
	
exception
	when no_data_found then
	dbms_output.put_line('Invalid event-reservation ID !...');
end;
/

create or replace function service_income_by_reservation(p_ev_re_id in number)
return number
as
    cursor c1 is select sum(CASE
				WHEN service_type.service_applies = 'per_person'
				THEN event_reservation.no_of_people * service_type.service_amount
				ELSE service_type.service_amount
				END) as service_cost 
    from service_reservation, service_type, event_reservation 
    where service_reservation.event_reservation_id = event_reservation.event_reservation_id 
	and service_reservation.service_id = service_type.service_id 
	and event_reservation.event_reservation_id = p_ev_re_id
	group by event_reservation.event_reservation_id ;
    
	p_service_cost number;
    
begin
	check_res_id(p_ev_re_id);
	
	open c1;
	loop
    fetch c1 into p_service_cost;
    exit when c1%notfound;
	dbms_output.put_line('service income by ' || p_ev_re_id || ' event-reservation are: ' || p_service_cost);
	
	return p_service_cost;
	
	end loop;
	close c1;
exception 
	when no_data_found then
	dbms_output.put_line('Invalid Data !...');
	return -1;
	
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;
/

create or replace function get_event_duration (p_event_reservation_id in number)
return number
as

	e_duration number;
begin
	select (end_date - start_date) into e_duration from event_reservation where event_reservation_id = p_event_reservation_id; 
	
	if e_duration = 0 then 
	e_duration := 1;
	else 
	e_duration := e_duration + 1;
	end if;
	return e_duration;

exception
	when no_data_found then
	dbms_output.put_line('Invalid Data!...');
	return -1;
end;
/

create or replace function get_roominvoice_perday(p_event_res_id in number)
return number
as
	r_invoice number;
begin 
	 select room_invoice into r_invoice from event_reservation where event_reservation_id = p_event_res_id;
	 return r_invoice;
	 
exception 
	when no_data_found then
	dbms_output.put_line('Invalid Data !...');
	return -1;
	
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;
/

create or replace function get_discount ( p_eve_res_id in number)
return number

IS
	p_discount number;
	p_duration number;
	
begin

	select (start_date - date_of_reservation)into p_duration from event_reservation where event_reservation_id = p_eve_res_id;
	p_discount :=0;
		if p_duration >= 60
		then p_discount := 10;
		end if;
	dbms_output.put_line('Discount for ' ||p_eve_res_id|| ' is: ' || p_discount);
	return p_discount;
	
exception
	when no_data_found then
	dbms_output.put_line('Invalid Data!...');
	return -1;
End;
/

create or replace procedure state_income_report(p_state in varchar)
as

cursor c1 is select event_reservation.event_reservation_id 
			from event_reservation, hotel
			where event_reservation.hotel_id = hotel.hotel_id
			and hotel.state = p_state;
			
	e_reservation_id number;
	total_event_days number;
	roominvoice_perday number;
	room_cost number;
	service_cost number;
	discount number;
	total_cost number;
	grand_total number :=0 ;
	
begin
	dbms_output.put_line('-----> income report of state : ' || p_state);
	open c1;
	loop
		fetch c1 into e_reservation_id;
		exit when c1%notfound;
		
		service_cost := service_income_by_reservation(e_reservation_id);
		
		total_event_days := get_event_duration(e_reservation_id);
		roominvoice_perday := get_roominvoice_perday(e_reservation_id);
		room_cost := total_event_days * roominvoice_perday;
		dbms_output.put_line('Room income by ' || e_reservation_id || ' event-reservation are: ' || room_cost);
		
		
		discount := get_discount(e_reservation_id);
		
		total_cost := room_cost + service_cost - discount;
		
		dbms_output.put_line('The total cost for '|| e_reservation_id|| ' event-reservation is: '|| total_cost);
		dbms_output.put_line('-----------------------------------------------------------------------------------');
		grand_total := grand_total + total_cost;
	
	end loop;
	close c1;
		dbms_output.put_line('The grand total of all events income from ' || p_state|| ' state is : '|| grand_total);

exception
	when others then
	dbms_output.put_line('please contact your administrator!...');
	raise;
	
end;		
/
-----Executing the procedure for feature 21-----
--Income for AK, MD (two calls)

SET SERVEROUTPUT ON;
exec state_income_report('Maryland');
/	 
SET SERVEROUTPUT ON;
exec state_income_report('Alaska');
/	 
