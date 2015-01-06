Moodtech_Features
===========

This repo is for the test suite aimed at moodtech-staging and will be used to test the app via Selenium and SauceLabs

##To run this test suite:

You will need to set the following environment variables. You will need to set user roles appropriate to Super User
(User in this test suite), Clinician, Researcher, and Content Author.

    Base_URL; Participant_Email; Participant_Password; Old_Participant_Email; Old_Participant_Password; User_Email;
    User_Password; Clinician_Email; Clinician_Password; Researcher_Email; Researcher_Password; Content_Author_Email;
    Content_Author_Password

To run on Sauce Labs you will need to set the following environment variables, otherwise you can run it locally on your
machine:

    SAUCE_USERNAME; SAUCE_ACCESS_KEY

To run the test suite against the staging server simply run:

    $ rspec