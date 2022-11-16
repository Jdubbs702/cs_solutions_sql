-- get description of crime in question
SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = "Humphrey Street";
-- theft occurred at 10:15am at bakery

-- get testimony of 3 witnesses from interviews table
SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28
AND year = 2021;
-- thief withdrew $ from atm on Leggett Street before theft
-- thief left in a car from bakery within 10 min of theft
-- thief made a < 1 minute call after theft;
-- thief plans to depart fiftyville on 1st flight tomorrow (7-29-2021)
-- accomplice suspected to buy flight ticket

-- set up common table expression so I can refer back to the thief
WITH mastermind AS (
    -- Table mastermind
    -- PROCESS TO FIND THIEF:
    -- get suspect info on people whose bank account numbers match
    -- the day's Leggett atm withdrawals and
    -- match the plates that are in the bakery security logs and
    -- whose phone numbers match the phone number that made a < 1 minute call after the theft and
    -- whose passport number matches passport number of passengers with the corresponding flight info
    SELECT name, phone_number, passport_number
    FROM people JOIN bank_accounts ON (bank_accounts.person_id = people.id)
    WHERE license_plate IN
    (
    -- get plates of suspects from bakery security footage
        SELECT license_plate
        FROM bakery_security_logs
        WHERE month = 7 AND day = 28
        AND year = 2021 AND hour = 10
        AND minute <= 25 AND activity = "exit"
        AND account_number IN
        (
            -- get matching acct #s
            SELECT account_number
            FROM atm_transactions
            WHERE month = 7 AND day = 28
            AND year = 2021 AND atm_location = "Leggett Street"
            AND transaction_type = "withdraw"
        )
        AND phone_number IN
        (
            -- get matching phone number
            SELECT caller
            FROM phone_calls
            WHERE year = 2021 AND month = 7
            AND day = 28 AND duration <= 60
        )
        AND passport_number IN
        (
            -- get matching passport number
            SELECT passport_number
            FROM passengers JOIN flights ON (passengers.flight_id = flights.id)
            WHERE flight_id =
            (
                -- get flight info
                SELECT flights.id
                FROM flights JOIN airports ON (flights.origin_airport_id = airports.id)
                WHERE year = 2021 AND month = 7 AND day = 29
                AND city = "Fiftyville"
                ORDER BY hour LIMIT 1
            )
        )
    )
)

SELECT mastermind.name as Thief, getaway.city as Escaping_To, partner.name as Accomplice
FROM mastermind, (
    -- Table partner
    -- PROCESS TO FIND ACCOMPLICE
    -- find person whose phone # matches number in phone log where:
    -- Thief's # matches caller, day, and duration to get receivers phone #
    SELECT name
    FROM people
    WHERE phone_number IN
    (
        -- get receivers phone numbers
        SELECT receiver
        FROM phone_calls
        -- thief's phone number from mastermind CTE
        WHERE caller IN (SELECT phone_number FROM mastermind)
        AND day = 28
        AND duration <= 60
    )
) AS partner,
(
    SELECT city
    FROM airports
    WHERE id IN
    (
        SELECT destination_airport_id
        FROM flights JOIN passengers ON (flights.id = passengers.flight_id)
        -- thief's passport number from mastermind CTE
        WHERE passport_number = (SELECT passport_number FROM mastermind)
    )
) AS getaway;