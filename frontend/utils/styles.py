DARK_THEME_CSS = """
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

html, body, [class*="css"] {
    font-family: 'Inter', sans-serif !important;
}

#MainMenu, footer, header { visibility: hidden; }

.stApp { background: #191919 !important; }

[data-testid="stSidebar"] {
    background: #202020 !important;
    border-right: 1px solid #2f2f2f !important;
}
[data-testid="stSidebarNav"] { display: none; }

.stButton > button {
    border-radius: 8px !important;
    font-size: 15px !important;
    font-weight: 500 !important;
    border: 1px solid #3a3a3a !important;
    background: transparent !important;
    color: #ccc !important;
    padding: 8px 18px !important;
    transition: all 0.15s ease !important;
}
.stButton > button:hover {
    background: #2a2a2a !important;
    border-color: #555 !important;
    color: #fff !important;
}
.stButton > button[kind="primary"] {
    background: #7F77DD !important;
    border-color: #7F77DD !important;
    color: #fff !important;
}
.stButton > button[kind="primary"]:hover {
    background: #6a62c4 !important;
}

.stTextInput > div > div > input,
.stTextArea > div > div > textarea,
.stSelectbox > div > div {
    background: #2a2a2a !important;
    border: 1px solid #3a3a3a !important;
    border-radius: 8px !important;
    color: #e8e8e8 !important;
    font-size: 15px !important;
}
.stTextInput > div > div > input:focus,
.stTextArea > div > div > textarea:focus {
    border-color: #7F77DD !important;
    box-shadow: 0 0 0 3px rgba(127,119,221,0.15) !important;
}

[data-testid="stMetric"] {
    background: #222 !important;
    border: 1px solid #2f2f2f !important;
    border-radius: 12px !important;
    padding: 16px 20px !important;
}
[data-testid="stMetricValue"] {
    font-size: 28px !important;
    font-weight: 600 !important;
    color: #e8e8e8 !important;
}
[data-testid="stMetricLabel"] {
    font-size: 13px !important;
    color: #666 !important;
}

.stProgress > div > div {
    background: #7F77DD !important;
    border-radius: 4px !important;
}
.stProgress > div {
    background: #2f2f2f !important;
    border-radius: 4px !important;
}

.streamlit-expanderHeader {
    background: #222 !important;
    border: 1px solid #2f2f2f !important;
    border-radius: 8px !important;
    color: #e8e8e8 !important;
    font-size: 15px !important;
}
.streamlit-expanderContent {
    background: #1e1e1e !important;
    border: 1px solid #2f2f2f !important;
    border-top: none !important;
    border-radius: 0 0 8px 8px !important;
}

hr { border-color: #2f2f2f !important; margin: 16px 0 !important; }

::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: #191919; }
::-webkit-scrollbar-thumb { background: #3a3a3a; border-radius: 2px; }

[data-testid="stForm"] {
    background: #222 !important;
    border: 1px solid #2f2f2f !important;
    border-radius: 12px !important;
    padding: 20px !important;
}

label, .stLabel {
    color: #666 !important;
    font-size: 14px !important;
    font-weight: 500 !important;
}

.stSuccess {
    background: rgba(29,158,117,0.12) !important;
    border: 1px solid rgba(29,158,117,0.3) !important;
    border-radius: 8px !important;
    color: #5DCAA5 !important;
    font-size: 15px !important;
}
.stWarning {
    background: rgba(186,117,23,0.12) !important;
    border: 1px solid rgba(186,117,23,0.3) !important;
    border-radius: 8px !important;
    font-size: 15px !important;
}
.stError {
    background: rgba(226,75,74,0.12) !important;
    border: 1px solid rgba(226,75,74,0.3) !important;
    border-radius: 8px !important;
    font-size: 15px !important;
    color: #f09595 !important;
}

.stDownloadButton > button {
    border-radius: 8px !important;
    font-size: 15px !important;
    font-weight: 500 !important;
    width: 100% !important;
    background: #222 !important;
    border: 1px solid #3a3a3a !important;
    color: #ccc !important;
}
.stDownloadButton > button:hover {
    border-color: #7F77DD !important;
    background: #2a2a2a !important;
}

.stRadio > div { background: transparent !important; }

.stSelectbox > div > div > div {
    color: #e8e8e8 !important;
    font-size: 15px !important;
}

p { font-size: 15px !important; line-height: 1.7 !important; }
</style>
"""

SIDEBAR_HTML = """
<div style="padding:8px 0 20px;">
    <div style="display:flex;align-items:center;gap:10px;">
        <div style="width:32px;height:32px;border-radius:8px;
        background:#7F77DD;
        display:flex;align-items:center;justify-content:center;
        font-size:14px;font-weight:700;color:#fff;">D</div>
        <div>
            <div style="font-size:15px;font-weight:600;color:#e8e8e8;">
            DocForge Hub</div>
            <div style="font-size:10px;color:#555;">
            AI Document Generation</div>
        </div>
    </div>
</div>
<div style="font-size:9px;font-weight:700;color:#444;
letter-spacing:1.2px;text-transform:uppercase;
margin-bottom:6px;padding-left:4px;">Workspace</div>
"""