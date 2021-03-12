DB_NAME = "MRP_ROMP"
SERVER_NAME = "localhost"

SCHEMA_NAME ={
    "new": "new",
    "old": "old",
    "generic": "generic"
}

LOAD_SURVEY_TYPES = {
    "resident":"resident",
    "student":"student"
}

TABLE_NAME ={
    "preceptor": "Vw_DimPreceptor",
    "university": "Vw_DimUniversity",
    "rotation": "Vw_DimRotation",
    "community": "Vw_DimCommunity",
    "accommodation_rating": "Vw_DimAccomodation",
    "community_involvement": "Vw_DimCommunityInvolvement",
    "knowledge_acquisition": "Vw_DimKnowledgeAcquisition",
    "preceptor_rating": "Vw_DimPreceptorRating",
    "ROMP_rating": "Vw_DimROMPRating",
    "respondent_answer": "Vw_DimRespondentAnswer",
    "question": "Vw_DimQuestion",
    "answer": "Vw_DimAnswer",
    "respondent": "Vw_FactRespondent"
}

PROCEDURE_NAME ={
    "question": "SP_DIM_QUESTION",
    "university": "SP_DIM_UNIVERSITY",
    "rotation": "SP_DIM_ROTATION",
    "preceptor": "SP_DIM_PRECEPTOR",
    "community": "SP_DIM_COMMUNITY_HOSPITAL",
    "answer": "SP_DIM_ANSWER",
    "accommodation_rating": "SP_DIM_ACCOMODATION",
    "community_involvement": "SP_DIM_COMMUNITY_INVOLVEMENT",
    "knowledge_acquisition": "SP_DIM_KNOWLEDGE_ACQUISITION",
    "preceptor_rating": "SP_DIM_PRECEPTOR_RATING",
    "ROMP_rating": "SP_DIM_ROMP_STAFF_RATING",
    "respondent_answer": "SP_DIM_RESPONDENT_ANSWER",
    "respondent": "SP_FACT_RESPONDENT"
}

EXTRACT_FILE_NAME = {
    "new": "New_Clean_Student_Resident_Data.xlsx",
    "old": "Old_Clean_Student_Resident_Data.xlsx"
}

NEW_FILE_NAME ={
    "student": "New Medical Student and Clerk Rotation Evaluation.xlsx",
    "resident": "New Resident Rotation Evaluation.xlsx"
}

OLD_FILE_NAME ={
    "student": "Old Medical Student and Clerk Rotation Evaluation.csv",
    "resident": "Old Resident Rotation Evaluation.xlsx"
} 