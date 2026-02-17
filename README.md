# TenderTrust – Verified Childcare Platform

**Team Name:** TrustForge  

TenderTrust is a secure and transparent childcare discovery platform built using **Flutter (Dart)** and **Firebase**.

The application connects parents with verified caregivers while ensuring trust, safety, and real-time transparency during childcare sessions.

---

## Problem Statement

Parents searching for babysitters or caregivers often lack a trusted platform to verify background credentials, review ratings, and receive real-time updates. This gap creates significant safety and transparency concerns.

TenderTrust addresses these challenges by providing:

- Verified caregiver profiles  
- Transparent review system  
- Real-time activity updates  
- Emergency safety features  

---

## Objective

To develop a secure childcare marketplace that enhances:

- Trust between parents and caregivers  
- Transparency during childcare sessions  
- Accountability through structured verification and reviews  
- Safety via integrated emergency mechanisms  

---

## Technology Stack

### Frontend
- Flutter (Dart)

### Backend & Services
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging (FCM)

---

## User Roles

### Parent

- Register and log in  
- Browse verified caregivers  
- Send booking requests  
- Receive real-time session updates  
- Rate and review caregivers  
- Receive emergency alerts  

### Caregiver

- Register and create a professional profile  
- Upload verification documents  
- Accept or reject booking requests  
- Send live activity updates  
- Trigger SOS emergency alerts  

---

## Core Features (MVP)

### 1. Role-Based Authentication

- Email and password login  
- Parent and caregiver role selection  
- Secure user management using Firebase Authentication  

---

### 2. Caregiver Verification System

- Upload government-issued identification  
- Verified badge displayed on profile upon approval  
- Admin approval simulation for MVP  

---

### 3. Caregiver Profiles

Each profile includes:

- Name  
- Experience  
- Location  
- Hourly rate  
- Professional bio  
- Average rating  
- Verification status  

---

### 4. Booking System

- Parents can send booking requests  
- Caregivers can accept or reject requests  
- Booking status tracking:
  - Pending  
  - Accepted  
  - Ongoing  
  - Completed  
  - Emergency  

---

### 5. Transparent Rating System

- Reviews allowed only after completed bookings  
- 1–5 star rating system  
- Automatic average rating calculation  
- Each review linked to a specific booking ID  

---

### 6. Real-Time Activity Updates

During an active session, caregivers can update:

- Session Started  
- Meal Given  
- Nap Time  
- Play Time  
- Session Ended  

Parents receive updates instantly through Firestore real-time streams.

---

### 7. Emergency SOS Feature

- Caregiver can trigger an emergency alert  
- Parent receives instant notification  
- Booking automatically marked as "Emergency"  

---

## Security Measures

- Firebase Authentication for secure login  
- Role-based Firestore security rules  
- Only verified caregivers visible to parents  
- Reviews restricted to completed bookings  
- Secure document storage using Firebase Storage  

---

## Future Enhancements

- In-app messaging  
- Availability calendar  
- Live location tracking  
- Secure payment integration  
- Administrative dashboard  
- Smart caregiver recommendation system  

---

## Why TenderTrust?

TenderTrust addresses critical childcare concerns by ensuring:

- Trust through structured verification  
- Transparency through real-time updates  
- Accountability via authenticated reviews  
- Safety through emergency response mechanisms  

The platform modernizes childcare discovery into a secure, reliable, and technology-driven digital experience.
