from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import numpy as np
import os

# ================================
# AgriSmart - Crop Recommendation API
# Run: uvicorn main:app --reload
# Docs: http://localhost:8000/docs
# ================================

app = FastAPI(
    title="AgriSmart API",
    description="ML-powered Crop Recommendation System",
    version="1.0.0"
)

# Allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load ML Models
MODEL_PATH = "crop_model.pkl"
SCALER_PATH = "scaler.pkl"
ENCODER_PATH = "label_encoder.pkl"

model = None
scaler = None
label_encoder = None

@app.on_event("startup")
def load_models():
    global model, scaler, label_encoder
    try:
        model = joblib.load(MODEL_PATH)
        scaler = joblib.load(SCALER_PATH)
        label_encoder = joblib.load(ENCODER_PATH)
        print("✅ ML Models loaded successfully!")
    except FileNotFoundError:
        print("⚠️  Model files not found. Run Jupyter notebook first!")


# ================================
# Request / Response Models
# ================================

class CropInput(BaseModel):
    nitrogen: float = Field(..., ge=0, le=200, description="Nitrogen content (N)")
    phosphorus: float = Field(..., ge=0, le=200, description="Phosphorus content (P)")
    potassium: float = Field(..., ge=0, le=200, description="Potassium content (K)")
    temperature: float = Field(..., ge=0, le=60, description="Temperature in Celsius")
    humidity: float = Field(..., ge=0, le=100, description="Humidity percentage")
    ph: float = Field(..., ge=0, le=14, description="Soil pH level")
    rainfall: float = Field(..., ge=0, le=500, description="Rainfall in mm")

    class Config:
        json_schema_extra = {
            "example": {
                "nitrogen": 90,
                "phosphorus": 42,
                "potassium": 43,
                "temperature": 20.87,
                "humidity": 82.0,
                "ph": 6.5,
                "rainfall": 202.93
            }
        }

class CropRecommendation(BaseModel):
    recommended_crop: str
    confidence: float
    top_3: list
    message: str


# ================================
# API Endpoints
# ================================

@app.get("/")
def root():
    return {
        "app": "AgriSmart",
        "status": "running",
        "message": "Crop Recommendation API is live! 🌾",
        "docs": "/docs"
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "model_loaded": model is not None,
        "scaler_loaded": scaler is not None
    }

@app.post("/predict", response_model=CropRecommendation)
def predict_crop(data: CropInput):
    if model is None:
        raise HTTPException(
            status_code=503,
            detail="Model not loaded. Run Jupyter notebook first to train and save the model."
        )

    try:
        # Prepare input
        input_data = np.array([[
            data.nitrogen,
            data.phosphorus,
            data.potassium,
            data.temperature,
            data.humidity,
            data.ph,
            data.rainfall
        ]])

        # Scale input
        input_scaled = scaler.transform(input_data)

        # Predict
        prediction = model.predict(input_scaled)
        probabilities = model.predict_proba(input_scaled)[0]

        # Get crop name
        crop_name = label_encoder.inverse_transform(prediction)[0]
        confidence = float(max(probabilities)) * 100

        # Top 3 recommendations
        top3_idx = np.argsort(probabilities)[::-1][:3]
        top3_crops = label_encoder.inverse_transform(top3_idx)
        top3_proba = probabilities[top3_idx]

        top_3 = [
            {"crop": str(crop), "confidence": round(float(prob) * 100, 2)}
            for crop, prob in zip(top3_crops, top3_proba)
        ]

        return CropRecommendation(
            recommended_crop=crop_name,
            confidence=round(confidence, 2),
            top_3=top_3,
            message=f"Based on your soil and weather conditions, {crop_name} is the best crop to grow!"
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/crops")
def get_all_crops():
    """Get list of all crops the model can recommend"""
    if label_encoder is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    crops = label_encoder.classes_.tolist()
    return {
        "total_crops": len(crops),
        "crops": crops
    }


# ================================
# Run locally
# ================================
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
