MoodTech Features
===========

This repo is for the test suite aimed at moodtech-staging and will be used to 
test the app via Selenium and SauceLabs

## To run this test suite:

You will need to set up the following participants and users in the app:

  * Participant - an active participant in a social arm with access to most 
  tools (see tests for granular detail)
  * Old_Participant - an inactive participant 
  * Alt_Participant - an active participant in a social arm with access to 
  many tools (see tests for granular detail)
  * NS_Participant - an active participant in a non-social arm with access to 
  many tools (see tests for granular detail)
  * Completed_Pt - a participant who's flagged as completed
  * User - user given a super user role
  * Clinician - user with a clinician role
  * Researcher - user with a researcher role
  * Content_Author - user with a content author role

You will need to set the following environment variables that correspond to 
the participants and users above as well as a couple of pieces of data for 
specific tests. These are set as environment variables to protect sensitive 
data as well as access to the application. The  "Participant_Phone_Number" 
variable is formatted 18885559999 while the "Participant_Phone_Number_1" 
is formatted 1(888) 555-9999. The "Audio_File" variable is a URL specific to 
the app. 

    Base_URL; Participant_Email; Participant_Password; Old_Participant_Email;
    Old_Participant_Password; Alt_Participant_Email; Alt_Participant_Password; 
    NS_Participant_Email; NS_Participant_Password; Completed_Pt_Email; 
    Completed_Pt_Password;User_Email; User_Password; Clinician_Email; 
    Clinician_Password; Researcher_Email; Researcher_Password; 
    Content_Author_Email; Content_Author_Password; Participant_Phone_Number;
    Participant_Phone_Number_1; Audio_File

To run on Sauce Labs you will need to set the following environment variables, 
otherwise you can run it locally on your machine:

    SAUCE_USERNAME; SAUCE_ACCESS_KEY

To run the suite simply run:

    $ rpsec