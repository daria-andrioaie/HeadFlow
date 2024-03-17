
# HeadFlow

HeadFlow is an iOS app that provides assisted rehabilitation for patients with cervical spine issues.

Essentially, while the patient performs the recovery protocol established by his therapist (a set of exercises), the app will detect his head motion and track his progress over time. 


## Why?
Neck pain and, subsequently, decreased neck mobility, is a common problem that affects people from all walks of life nowadays. In fact, researchers consider it to be a widespread issue in modern society, due to several factors, such as improper posture at the workplace, stress, anxiety and depression.

On a more optimistic note, kinesiotherapy has long been found to help patients regain their normal range of motion, reduce pain and discomfort, and improve their overall quality of life. With proper guidance from a trained kinesiotherapist, patients can experience significant improvements in their symptoms and regain the ability to perform daily activities with ease. ⛹🏼

However, when patients are considered recovered and interrupt the kinesiotherapy sessions, they are advised to continue the exercise protocol at home, to prevent a relapse. Unfortunately, most of them, as studies show, find it hard to stay accountable at home and many of symptoms reappear after a few weeks or months. 

HeadFlow is the perfect solution in this scenario. 🥳 


## How?
HeadFlow accommodates two types of users: patients and their therapists.

Therapists put together a series of exercises with specific durations and ranges, depending on the needs of each patient. The patient will then be reminded to perform the exercises daily, and the therapist will be able to monitor their progress, keeping them accountable. 

The key strength of HeadFlow is **motion tracking**, through the updates provided by **CMHeadphoneMotionManager**, from CoreMotion. The app monitors the movement of the patient with great precision, providing meaningful data for the therapist. Of course, the therapist can provide feedback for each session and adjust the protocol accordingly. 


## Demo

### Patient flow 
![](https://github.com/daria-andrioaie/HeadFlow/blob/main/resources/patient/patient_demo_sped_up.gif)

### Perform stretching session
![](https://github.com/daria-andrioaie/HeadFlow/blob/main/resources/patient/demo-sped-up.gif)

### Therapist flow
![](https://github.com/daria-andrioaie/HeadFlow/blob/main/resources/therapist/therapist_demo_sped_up.gif)



## Documentation

The theoretical paper of this project can be seen [here](Theoretical_Paper.pdf). It contains some background research, describes motivation of the features more thouroughly and depicts implementation details.  

