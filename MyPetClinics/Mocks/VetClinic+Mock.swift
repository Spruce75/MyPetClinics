//
//  VetClinic+Mock.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 13.6.2025.
//

import Foundation

extension VetClinic {
    static let sampleStatusOy = VetClinic(
        name: "Eläinlääkäriasema Status Oy",
        address: "Pyynikintori 8",
        postalCode: "33230",
        city: "Tampere",
        country: "Finland",
        websiteURL: URL(string: "http://elainlaakariasemastatus.fi/")!,
        phoneNumber: "060092110",
        email: "info@elainlaakariasemastatus.fi",
        rating: 3,
        emergencyInfo: "24/7 – emergency services",
        description:
            """
            Status Veterinary Clinic is a private Finnish veterinary clinic that has been operating for 7 years in the center of Tampere. It provides hospital-level care for your pet 24/7 and offers emergency services on weekends and public holidays.
            """,
        pricesText:
                """
                WEEKDAY PRICES
                (Regular weekday consultations are currently unavailable.)
                VETERINARY VISIT
                (Includes consultation and clinic fee; additional procedures, medications, and supplies are charged separately.)
                * Basic consultation on weekdays: €78-230
                * The price is determined by the total duration of the visit.
                VACCINATIONS:
                * Single vaccine: €65
                * Two vaccines: €76 Note: Vaccination includes a general health check and the vaccine itself. If you wish to discuss a specific health issue in detail during the visit, an additional procedure fee will be charged based on a basic consultation. If your pet has a health problem, we recommend booking a separate appointment for examination before vaccination.
                * Microchipping: €78
                * Microchipping during another procedure: €34
                * Pet passport (as a standalone procedure): €89
                * Pet passport during another procedure: €46
                OTHER PROCEDURES:
                * Sedation: €25
                * Short intravenous anesthesia: €35 + medications (usually €15-20)
                * Fluid therapy: from €100
                * Ultrasound examination: €50-70
                * X-ray: €100 for the first image, +€30 per additional image

                DENTAL CARE:
                Tartar removal:
                * Cat: from €235
                * Dog: €295-440 (depending on the size of the dog and amount of tartar)
                Dental X-ray (during another procedure, e.g., tartar removal):
                * Single area: €50
                * Full mouth: €125
                Dental surgery
                (Price depends on procedure complexity and time required.)
                * Periodontitis 1: from €350 (e.g., removal of a few single-root teeth)
                * Periodontitis 2: from €550 (e.g., a few single-root and one surgical extraction)
                * Periodontitis 3: from €700 (e.g., multiple surgical extractions or one complex surgical removal)
                * Periodontitis 4: from €800 (extensive dental reconstruction)
                Complex dental procedures can take hours, but prolonged anesthesia is not ideal for pets. Therefore, extractions may be performed in two separate anesthesia sessions, typically 1-2 weeks apart.
                The veterinarian will provide a more precise cost estimate during the dental check-up upon request.
                Deciduous canine tooth removal (milk teeth):
                * 1-4 teeth: €360-545 + medications (usually €25-60)

                SURGERIES (Prices do not include medications.)
                Dog spaying (sterilization):
                * Under 10 kg: from €490
                * 10-30 kg: from €590
                * Over 30 kg: from €680
                Dog neutering (castration):
                * Under 10 kg: from €340
                * 10-30 kg: from €380
                * Over 30 kg: from €440
                Cryptorchid surgery – abdominal or inguinal testicle removal:
                * Under 10 kg: from €480
                * 10-30 kg: from €560
                * Over 30 kg: from €670
                Cryptorchid surgery – subcutaneous testicle removal (between scrotum and inguinal canal):
                * Under 10 kg: from €441
                * 10-30 kg: from €510
                * Over 30 kg: from €570
                Cat surgeries:
                * Neutering: from €105
                * Spaying: from €220
                Other surgeries:
                * Pyometra surgery: from €890
                * C-section: from €830
                * Umbilical hernia surgery: from €259
                * Bladder stone removal: from €800
                For other surgeries, please request a case-specific price estimate.

                FOR BREEDERS:
                * Pregnancy X-ray (about a week before due date): €110
                * Pregnancy ultrasound: €100
                * For litter health check inquiries, please contact us via email.

                LABORATORY SERVICES:
                * Comprehensive blood tests at the clinic: ~€150
                * Ear swab test: €40
                * Urine test: €60
                Our laboratory can analyze blood samples, cytology, pancreatic lipase, inflammatory markers (CRP, SAA), coagulation factors, and blood type. We also collaborate with external veterinary laboratories.

                EUTHANASIA:
                * Euthanasia: ~€150-180
                * Small animals under 1 kg: ~€100
                * Cremation is charged separately. We collaborate with Verna Crematorium.

                EMERGENCY SERVICE
                GENERAL VISIT:
                * Short emergency consultation: from €180-200 (excluding medications and procedures)
                * Fee increases with consultation time (max. €280).
                EXAMPLES OF PROCEDURE COSTS:
                * Comprehensive blood tests: ~€150
                * Ear swab test: €40
                * Urine test: €60
                * Sedation: €25
                * Short intravenous anesthesia: €35 + medications (~€15-20)
                * Fluid therapy: from €100
                * Ultrasound: €50-70
                * X-ray: €100 (first image) + €30 per additional image
                * Hospitalization:
                    * Half-day: from €500
                    * Full-day: from €1000 (Procedures performed during hospitalization are charged separately.)
                EXAMPLES OF EMERGENCY SURGERIES:
                (These prices include consultation and diagnostics.)
                * Pyometra surgery: from €1600 (incl. ultrasound and consultation)
                * C-section: from €1600 (incl. ultrasound)
                * Gastric torsion surgery: from €3500
                * Wound suturing: from €350
                EUTHANASIA:
                * Euthanasia: €250-350
                * Small animals under 1 kg: €150
                * Cremation is charged separately. We collaborate with Verna Crematorium.
                """,
        instagramURL: URL(string: "https://www.instagram.com/elainlaakariasemastatus/"),
        facebookURL: URL(string: "https://www.facebook.com/ElainlaakariasemaStatus/"),
        
        staff: [
            StaffMember(name: "Milla Solja, veterinarian",       imageName: "Milla Solja", bio: ""),
            StaffMember(name: "Laura Hynninen, veterinary nurse",    imageName: "Laura Hynninen", bio: ""),
            StaffMember(name: "Marika Lakkala, veterinary nurse",imageName: "Marika Lakkala", bio: ""),
            StaffMember(name: "Kirsi Asikainen, veterinarian",   imageName: "Kirsi Asikainen", bio: ""),
            StaffMember(name: "Natalia Tirkkonen, veterinarian", imageName: "Natalia Tirkkonen", bio: "")
        ],
        clinicPhotos: ["Status 1", "Status 2", "Status 3"],
        type: "Vet clinic",
        onlineConsultationAvailable: false,
        isBookmarked: false,
        latitude: 61.49770280571968,
        longitude: 23.743094338147202
    )

    static let samplePyynikinElainlaakarit = VetClinic(
        name: "Pyynikin Eläinlääkärit",
        address: "Sotkankatu 20",
        postalCode: "33230",
        city: "Tampere",
        country: "Finland",
        websiteURL: URL(string: "https://pyynikinelainlaakarit.fi")!,
        phoneNumber: "033891010",
        email: "info@pyynikinelainlaakarit.fi",
        rating: 4,
        emergencyInfo: "emergency services during working hours",
        description:
            """
            Pyynikin Eläinlääkärit is an independent Finnish veterinary clinic in Tampere, providing high-quality care for pets. Services range from dental surgery to orthopedics, with a focus on comprehensive treatment and customer experience.
            """,
        pricesText:
            """
            CONSULTATIONS ON WEEKDAYS
            Vet visit (15 min) – €97.50 For minor issues and prescription writing
            Vet visit (30 min) – €129 A bit more comprehensive: multiple prescriptions, possible blood sample (charged separately)
            Vet visit (45 min) – €168.50 Extensive consultation: investigation of chronic or multiple issues, in-clinic medications, additional procedures possible
            Vet visit (60 min) – €238.50 Thorough and time‑consuming case: diagnostics, in‑clinic treatment, additional procedures may be done
            Remote consultation – €69–109 Limited availability for non-regular patients; inquire by phone or email
            Bite/mouth consultation – €124 Dr. Kaisa Hörkkö

            EMERGENCY CARE (WEEKDAYS)
            We aim to accommodate urgent cases and provide first aid. Call to check for same-day openings.
            If fully booked, we may still accept walk-ins for emergencies—expect extended waiting.
            Outside opening hours, leave a callback request. We'll return your call as soon as possible the next morning.
            Surcharges:
            * If fully booked: +50% of procedure cost + higher clinic fee (€45).
            * If not fully booked: no surcharge.
            * Outside opening hours: +50–100% on visit price—applies if treatment continues past hours.

            VACCINATIONS
            Vaccination visits always include a general health check. For more thorough exams, see “Health Checks with Lab Tests.”
            * Single vaccine – €67.50
            * Two vaccines – €79.50
            * Health check + vaccine(s) – €108.50 Includes evaluation for rescue/adoption pets; additional testing and prescriptions planned
            * Vaccine with another procedure – €43–52.50
            Ask about group rates for 3+ pets!

            PUPPY VACCINATION PACKAGE – €182
            Includes 3 visits:
            1. Nurse visit (10–12 weeks): acclimation, playtime, nurse chat
            2. Vet visit (≥12 weeks): vaccinations (DHLPPi + rabies)
            3. Nurse visit (~5–6 months): handling, oral check, nails, owner training Rabies vaccine can be added for extra cost.

            SKIN & EAR ISSUES
            * Skin issues (15 min) – €110.25 Quick exam, e.g., minor rash
            * Skin issues, basic – €196.50 Includes cytology and treatment (lab fee for samples)
            * Skin issues, extensive – €228 For chronic/complex cases; includes cytology (additional lab fees)
            * Ear infection – from €220 Includes cytology; meds added
            * Ear re-check – €133.50 Cytology billed separately
            * Video otoscopy under sedation – €260 Cytology extra

            BASIC PROCEDURES
            * Tick prevention consultation – €29
            * 1-year tick injection – €29 + medication (~€40/10 kg + handling)
            * Eye infection treatment – €188.50
            * Urinary work-up – from €235.10 Includes bladder ultrasound + cysto; lab fees extra
            * Anal gland expression under sedation – from €267.50
            * Manual anal gland emptying (nurse) – €62.50
            * With another procedure – €28
            * Minor wound suturing – from €256.50
            * Stitch removal & follow-up (existing patients) – €0
            * Prescription issuance/renewal – €17.50
            * Pet passport – €94 / with another procedure €48.50 Includes past vaccine records
            * Microchip – €82 / with another procedure €35.50 Registration included
            * Patella exam – €66 / with another procedure €51
            * Heart auscultation – €67 / with another procedure €52
            * Blood pressure check (other) – €45 (recommended for senior cats)
            * Blood pressure + remote consult – €121
            * Blood draw – €57.50 (labs extra)
            * Pre-anesthetic blood work – €53.50 (labs extra)
            * Multi-resistant bacteria screen – €124.50 + lab €100–200 (for import dogs — ESBL, MRSA/MRSP, heartworm)
            * Echinococcus treatment – €41 / 3-visit course €61 Owner-supplied or provided, e.g., Drontal
            * Vet certificate – €50 (e.g., for tooth removal, insurance)
            * Nail trim (nurse) – €38 (pet must be handled by owner + nurse)
            * Nail trim under sedation – €121 (meds extra; only exceptions)
            * With other procedure – €10.50
            * Shaving under sedation – €185.50 (meds extra)
            * FeLV/FIV quick test (with other procedure) – €100
            * Fecal parasite test – €39 Campaign pricing of €39 valid through May 31, 2025
            * Injection by nurse – €40 + medication (e.g., Cytopoint)
            * Initial puppy exam without chip – €89.50 (first), €18.50 (each additional)
            * With microchip – €114.50 (first), €35 (additional) Add vaccine +€43 per puppy (includes one vaccine)

            DENTAL CARE, BITE ALIGNMENT, DENTAL ACCIDENTS
            * Dental needs assessment – €83
            * Bite/mouth consultation – €124 (Dr. K. Hörkkö)
            We offer extensive dental services under inhalation anesthesia: ultrasonic scaling, polishing, dental exam, treatment planning, and radiographs as needed.
            * Dog dental cleaning – €355.50–440.50 (size and tartar-dependent; meds extra) Dental members: €303
            * Cat dental cleaning – €301 (meds extra) Members: €256
            * Full-mouth radiograph – €126
            * 3–6 images – €76.50
            * Baby fang removal (1–4 teeth) – €488–601 (meds extra; additional teeth billed by time)
            * Tooth extractions:
                * Base fee €251.50 (anesthesia + prep)
                * 30 min – €575 + meds
                * 60 min – €830 + meds
                * Cat full extractions – €1,500 + meds
                * Risk anesthesia surcharge €38–50 (brachycephalic, >12 yrs, comorbidities)
            * Pulp amputation (1 tooth) – €830; (2 teeth) – €1020 (meds extra)
            * Root canal: dog canine
                * 1 session from €1,481; 2 sessions 2×€1,086
            * Cat canine root canal: 1 session from €803; 2 sessions 2×€650 (meds extra)
            * Tooth filling – €442 (composite)
                * With another procedure – €161
            * Tooth sealant under another procedure – from €55.50
            * Crown extensions / lower-canine realignment – ~€1,000 Requires at least 2 anesthesias + follow‑ups (€83.50 each)
            * Dental trauma treatment—specialized procedures available.

            HEALTH CHECKS WITH BLOOD/URINE
            Recommended annually, especially for older pets. Lab costs vary (~€130–200).
            * Vaccine + health check (no labs) – €108.50 (includes prescription updates or condition discussion; labwork extra)
            With labs:
            * Basic dog/cat exam + blood draw – €131.50
            * Senior/wellness exam + labs – €187.50
            * Blood pressure during same visit – €45
            * Cystocentesis urine sample – €36.50
            * Sedation for sampling – €48.50 (meds extra)

            SPAY/NEUTER SURGERY
            Medications included. Cone provided except for cats/rabbits. Recovery suits extra.
            Dogs:
            * Laparoscopic spay – €800–910.50 (recommended for >15 kg)
            * In-clinic spay (for existing clients) – €507.50–702.50
            * Neuter – €347–462
            * Chemical neuter – €210–298 (Suprelorin implant 6/12 mo)
            * Cryptorchid surgery (under skin) – €460.50–596.50
            * Laparoscopic cryptorchid – €710–870.50
            * Open cryptorchid – €499.50–699.50
            Cats:
            * Spay – €244.50
            * Neuter – €117.50
            * Early-spay (2–5 mo female) – €226
            * Early-neuter (2–4 mo male, descended) – €108
            * Cryptorchid (inguinal) – €334
            * Cryptorchid (abdominal) – €383.50
            Rabbit/guinea pig:
            * Neuter – €206.50
            * Spay – €282.50

            SOFT-TISSUE SURGERY
            Medications included.
            * Biopsy sampling (with procedure) – €134.50–380.50 Depends on number & complexity
            * Skin mass removal – from €375
            * Mammary tumor removal – €521–982 (scope-dependent) All masses sent for pathology (€107)
            * Gallbladder + liver biopsy – €1,236 (plus pathology & meds)
            * Abscess surgery – €913–1,110
            * Lip-fold surgery (half mouth) – €652.50
            * Digit amputation – €619
            * Tail amputation – €619
            * Splenectomy – €1,002
            * Foreign body surgery – €771
            * Foreign body removal from intestine – €1,107
            * Eye removal – cat €485.50, dog €684
            * Cesarean – €851.50
            * Umbilical hernia repair – €271.50
            * Bladder stone removal – €792.50–1,026 (x-ray optional)
            * Anal gland removal (dog, bilateral) – from €800
            Other procedures: prices on request

            ULTRASOUND & X‑RAY
            * Liver/gallbladder ultrasound – €206.90 (12 h fasting; sedation extra)
            * Quick ultrasound – €78.50 (with other)
            * Basic ultrasound – €100 (with other)
            * Extensive ultrasound – €170.40 (12 h fasting)
            * Tendon/muscle ultrasound – €78.50 (with other)
            * Pregnancy ultrasound – €107
            * Pregnancy X‑ray – €111.50
            * X‑ray (with other) – €158–241 (depends on number)
            * Official X‑rays (Kennel Club):
                * Hip – €197.50
                * Hip + elbow – €233
                * Hip + elbow + spine – €356 Arrange group rates (≥3 dogs) by calling/emailing.

            ORTHOPEDIA & LAMENESS
            * Quick lameness exam – €50.50 (with other)
            * Basic lameness visit – €187.50
            * Lameness exam + tests under sedation – €227 (often needed for cruciate issues)
            * Lameness diagnostics (with imaging under sedation):
                * 2–4 X‑rays from €345
                * Extended 5–10 images from €407.50
                * Ultrasound extra €78.50 (e.g., biceps tendon)
                * Fasting ≥8 h required
            * Joint injection – €249.50

            EUTHANASIA & CREMATION
            Medications included.
            * Euthanasia dog/cat (owner buries) – €157.50
            * Euthanasia dog/cat (cremation) – €180.50
            * Euthanasia small bird/rodent – €131.50
            * Euthanasia guinea pig/rabbit – €131.50
            * Cremation charged separately.
            Urns and memorial items available; see Pilvilinnan website.
            """,
        instagramURL: nil,
        facebookURL: URL(string: "https://www.facebook.com/pyynikinelainlaakarit"),
        
        staff: [
            StaffMember(
                name: "Kaisa Hörkkö (ent. Juhajoki), eläinlääkäri, ELL, yrittäjä",
                imageName: "Kaisa Hörkkö",
                bio:
                    """
                    Areas of expertise:
                    * Advanced dental care, including root canal treatments, pulpotomies, and simple orthodontic procedures
                    * Surgery
                    * Endoscopic surgeries
                    * Musculoskeletal disorders, orthopaedics
                    * Anaesthesiology
                    * Emergency and intensive care
                    I graduated as a veterinarian from the University of Helsinki in 2012 and have since mainly worked in small animal practice. Before founding my own clinic, I worked in various roles both as a municipal veterinarian and at small animal clinics. I have extensive experience in small animal dentistry, soft tissue surgery, and emergency care at animal hospitals. At Pyynikki, in addition to treating general patients, I perform advanced dental procedures such as root canals and soft tissue surgeries.
                    I founded Pyynikin Eläinlääkärit in autumn 2019, and our clinic's own premises were completed in April 2020. My goal with my own business is to create a workplace and clinic where both staff and patients with their owners feel comfortable — a place where a genuine love for animals and commitment to high-quality veterinary care is evident in every aspect of our work.
                    I continuously pursue further training, especially in the fields of surgery and dentistry. It's important to me to always consider the overall picture — both in the treatment of the pet and in the delivery of veterinary services.
                    At Pyynikin Eläinlääkärit, I treat all kinds of patients, perform a wide range of surgeries, dental procedures, and lameness examinations. At home, I have a smooth-coated retriever named Hupi. The photo also features my late toller, Vimma.
                    Further professional training includes:
                    * Ongoing: Improve International Small Animal Surgery program (~1.5 years) A comprehensive continuing education program in soft tissue surgery and orthopaedics
                    * TPLO Basic Course, Mathemedix 2025
                    * ESVOT Congress, Lisbon 2024 (Orthopaedics)
                    * Surgical Approaches to Long Bones and Joints, Mathemedix 2023
                    * Accesia Dentistry III (2023): Root canal therapy, pulpotomy, restorations
                    * ESAVS Dentistry III (2021): Root canal therapy, pulpotomy, restorations
                    * ESAVS Dentistry IV (2021): Orthodontics, prosthodontics, developmental dental anomalies
                    * ESAVS Orthopaedics I (2022)
                    * AOVET Principles of Fracture Management in the Dog and Cat (2019)
                    * ESAVS Soft Tissue Surgery I (2017)
                    * Fennovet: Dental Care in Dogs and Cats I (2015)
                    * Fennovet: Dental Radiography in Dogs and Cats (2016)
                    * Multiple smaller national and international courses annually
                    Memberships:
                    * Finnish Veterinary Association
                    * Finnish Small Animal Veterinary Association
                    Positions of trust:
                    * Member of the Finnish Veterinary Association's Education Committee since 2021
                    """
                       ),
            StaffMember(
                name: "Inês Lucas, eläinlääkäri",
                imageName: "Inês Lucas",
                bio:
                    """
                    Areas of expertise:
                    * Dentistry
                    * Ultrasound examinations
                    * Dermatology
                    * Internal medicine
                    I graduated as a veterinarian in 2012 from Vasco da Gama University (Coimbra, Portugal), after which I worked at several small animal clinics in Portugal.
                    Since 2017, I have been working as a veterinarian in Finland. I studied the Finnish language for a year and a half, but I also provide services in English and Portuguese. I joined Pyynikin Eläinlääkärit in March 2022.
                    In veterinary work, my main interests are dental diseases and oral surgery in dogs and cats, abdominal ultrasound examinations, dermatology, and internal medicine. I have completed several courses in dentistry, ultrasound diagnostics, and dermatology.
                    It is important for me to treat my patients calmly and respectfully, always prioritizing the animal’s comfort and needs. I do my best to ensure a positive experience for my patients, and in situations where that is not possible, I aim to minimize their stress as much as I can.
                    Dogs have always been my passion — I especially enjoy working with large breeds and rescue dogs. Although I never considered myself a “cat person,” working as a vet has taught me to love cats, and I now truly enjoy caring for feline patients.
                    In my free time, I enjoy singing and various crafts. I also love cooking and tending to my houseplants.
                    At home, I have a Great Dane–Mastiff mix named Luso, who came with me from Portugal.
                    Further professional training includes:
                    * ESAVS Dentistry I: Introduction to Dentistry, Diagnostics & Extractions
                    * Improve International: Introduction to Ultrasonography
                    * ESAVS Dermatology I
                    * ESAVS Diagnostic Ultrasound I
                    * Univets Abdominal Practical Course (May 2024)
                    """
            ),
            StaffMember(
                name: "Laura Penttilä (ent. Parviainen), eläinlääkäri, ELL",
                imageName: "Laura Penttilä",
                bio:
                    """
                    Areas of expertise:
                    * Dentistry
                    * Soft tissue surgery
                    * Musculoskeletal disorders
                    I graduated as a veterinarian from the University of Helsinki in 2018. Since then, I have worked in small animal practice, as a municipal veterinarian, and in official roles — mainly in animal welfare supervision.
                    I joined Pyynikin Eläinlääkärit in autumn 2022 after relocating to the Pirkanmaa region.
                    I enjoy treating a wide range of patients. In addition to cats and dogs, I also welcome smaller pets such as rabbits to my consultations.
                    I’m particularly passionate about soft tissue surgery and emergency-type cases. I also perform dental procedures and oral surgeries. My other areas of interest include animal welfare, behavioural disorders, and preventive healthcare. My core principles in patient care include respectful animal handling and treatment planning in collaboration with the owner — always taking the full picture and the animal’s quality of life into account.
                    At home, I have two Labrador Retrievers, Impi and Viski. I spend most of my free time outdoors with them, and on longer holidays, we often pack our backpacks and go hiking.
                    Further professional training includes:
                    * Small Animal Musculoskeletal Ultrasound, Fennovet 2024
                    * Fennovet: Practical Basics of Dental Care in Dogs and Cats
                    * Fennovet: Basics of Small Animal Ultrasound
                    * Animal Handling Skills and Training as a Tool in Veterinary Work
                    """
            ),
            StaffMember(
                name: "Elina Kiiskinen, eläinlääkäri, ELL",
                imageName: "Elina Kiiskinen",
                bio:
                    """
                    Areas of expertise:
                    * Feline medicine
                    * Dermatology
                    * Internal medicine
                    * Home euthanasia and other house calls
                    Elina joined Pyynikin Eläinlääkärit in January 2023. She has a broad interest in small animal medicine and enjoys treating a wide variety of patients. For Elina, open communication with clients and calm, friendly handling of animals are essential aspects of her work. She especially enjoys working with feline patients.
                    Elina’s family includes a joyful Labrador Retriever named Pepe and a Miniature Schnauzer named Henry.
                    Further professional training:
                    * CVE/ISFM Feline Medicine Distance Education Course, University of Sydney A two-year advanced program in feline medicine, started in February 2024 (ongoing)
                    """
            ),
            StaffMember(
                name: "Heidi Kemppainen, eläinlääkäri, ELL",
                imageName: "Heidi Kemppainen",
                bio:
                    """
                    Areas of expertise:
                    * All outpatient patients
                    * Basic surgical procedures
                    Heidi graduated as a veterinarian from the University of Helsinki in spring 2024. Before that, she worked in substitute roles as a municipal veterinarian. Heidi is highly motivated to care for all kinds of patients, with a particular interest in soft tissue surgery and treating musculoskeletal disorders. Animal behaviour is also close to her heart.
                    """
            ),
            StaffMember(
                name: "Heidi Remes, eläinlääkäri, ELL",
                imageName: "Heidi Remes",
                bio:
                    """
                    Areas of expertise:
                    * All outpatient patients
                    * Dentistry
                    * Basic surgical procedures
                    I will start working at Pyynikin Eläinlääkärit as a locum veterinarian in early March. I have a particular interest in surgery, but I treat a wide range of patients — from internal medicine and dermatological cases to dental care and behavioural issues. My goal with every patient is to find individual solutions that support a long and high-quality life.
                    Further professional training includes:
                    * ESAVS Dentistry I, II, IV
                    * Advanced Ultrasonography, Fennovet
                    """
            ),
            StaffMember(
                name: "Noora, klinikkaeläinhoitaja",
                imageName: "Noora",
                bio:
                    """
                    Noora graduated in 2012. Before joining the Pyynikki team, she spent nearly ten years working at a small animal clinic, gaining extensive experience and expertise in handling a wide range of situations — both in customer service and clinical care.
                    Noora has several strengths and areas of interest, including anaesthesia, laboratory work, and perioperative patient care. A true cat lover, she shares her home with two cats.
                    """
            ),
            StaffMember(
                name: "Vilma, klinikkaeläinhoitaja",
                imageName: "Vilma",
                bio:
                    """
                    Vilma graduated as a veterinary nurse in 2017. She especially enjoys working in the operating room and brings valuable expertise and confidence gained through experience to a wide range of procedures. Thanks to her solid background, she also serves as the primary supervisor for our student trainees at the clinic.

                    Vilma joined Pyynikin Eläinlääkärit in autumn 2021, coming from an emergency animal hospital. In her free time, she is kept busy by her two Dobermans, Sytkä and Olga, as well as her riding mare Lulu and her foal Köpö. She also has a passion for small-scale dog breeding. In the evenings, she’s accompanied by her lap cats: Oriental Shorthair Tirri, Burmese Fiona, and Abyssinian Loki.
                    """
            ),
            StaffMember(
                name: "Sari, klinikkaeläinhoitaja, klinikkamanageri",
                imageName: "Sari",
                bio:
                    """
                    Sari started with us as a trainee and progressed through an apprenticeship program to become a fully qualified veterinary nurse. Her sense of humor and positive attitude help carry the team through even the busiest days. Sari is customer-oriented and a strong team player.
                    As clinic manager, she is responsible for many aspects of the clinic’s daily operations. She also oversees the dental care department. At home, she shares her life with a German Shepherd named Tyyne.
                    """
            ),
            StaffMember(
                name: "Kati, klinikkaeläinhoitaja",
                imageName: "Kati",
                bio:
                    """
                    Kati began her journey with us as a trainee and later continued through an apprenticeship program, graduating as a veterinary nurse in 2022. She is diligent, meticulous, and deeply passionate about animals. Kati provides calm, friendly, and positive service to our clients.
                    She is also responsible for managing the clinic’s equipment and textile maintenance. Kati especially loves working with feline patients of all kinds.
                    In her free time, she enjoys equestrian sports and small-scale horse breeding. She also does crafts, goes to the gym, and during winter, you might spot her on the ski trails.
                    At home, Kati lives with two lovely cats: Jaakko the Burmese and Viljo the domestic shorthair.
                    """
            ),
            StaffMember(
                name: "Elina H, klinikkaeläinhoitaja",
                imageName: "Elina H",
                bio:
                    """
                    Elina started working with us as a veterinary nurse in autumn 2022. She is conscientious, precise, hardworking, and handles pressure well. Her favorite tasks include dental procedures, blood sampling, and various hands-on nursing duties.
                    Elina is responsible for maintaining the clinic’s operating room, X-ray, and ultrasound equipment. In her free time, she enjoys caring for other people’s dogs and loves spending time with them. She also enjoys helping out at horse stables.
                    Elina shares her life with an adorable cat named Duuveli — you might occasionally spot tiny Duuveli featured on our social media!
                    """
            ),
            StaffMember(
                name: "Anna Hietakangas, eläinfysioterapeutti",
                imageName: "Anna Hietakangas",
                bio:
                    """
                    Anna sees patients at our clinic on Saturdays.
                    Education:
                    * Specialisation in Animal Physiotherapy, 2021 – Satakunta University of Applied Sciences
                    * Bachelor of Health Care, Physiotherapy, 2016 – Tampere University of Applied Sciences
                    * Vocational Qualification in Agriculture, Animal Care, 2012 – Ahlman Vocational College
                    Further training:
                    * Stecco Fascial Manipulation for Dogs:
                        * Level 1 – February 2022
                        * Level 2 – February 2023
                    Anna is a member of the Finnish Association of Animal Physiotherapists (Suomen Eläinfysioterapeutit ry).
                    """
            ),
            StaffMember(
                name: "Kaisa L, klinikkaeläinhoitaja",
                imageName: "Kaisa L",
                bio:
                    """
                    Kaisa joined us as a veterinary nurse in spring 2023. Her responsibilities include managing the clinic’s social media channels, overseeing the endoscopy equipment, and handling occupational safety matters.
                    She brought with her several years of prior experience and especially enjoys anaesthesia monitoring and radiography. Animal-centered care and creating as stress-free a clinic experience as possible are the cornerstones of her work as a veterinary nurse.
                    Kaisa is a certified Kiva Käsittelijä (Kind Handler) through the dog training school Pawsiteam, and she has also studied low-stress handling extensively through various lectures and literature.
                    Animal welfare is a deeply important cause for Kaisa, and she actively promotes it on her personal social media in her free time. At home, she is accompanied by her dog Mango. The photo shows her late dog, Tuutti.
                    """
            ),
        ],
        clinicPhotos: ["Pyynikin Eläinlääkärit 1", "Pyynikin Eläinlääkärit 2", "Pyynikin Eläinlääkärit 3", "Pyynikin Eläinlääkärit 4", "Pyynikin Eläinlääkärit 5"],
        type: "Vet hospital",
        onlineConsultationAvailable: false,
        isBookmarked: false,
        latitude: 61.49842832458735,
        longitude: 23.741426106834922
    )

    static let mockData: [VetClinic] = [
        .sampleStatusOy,
        .samplePyynikinElainlaakarit
    ]
}
