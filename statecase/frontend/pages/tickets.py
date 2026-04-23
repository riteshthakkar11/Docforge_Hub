import requests
import pandas as pd
import streamlit as st
from statecase.frontend.config import API_BASE_URL

st.set_page_config(
    page_title="StateCase — My Tickets",
    page_icon="🎫",
    layout="wide"
)

with st.sidebar:
    st.header("🎫 Tickets")
    if st.button("💬 Back to Chat", use_container_width=True):
        st.switch_page("pages/chat.py")
    if st.button("🏠 Home", use_container_width=True):
        st.switch_page("app.py")

st.title("🎫 My Tickets")
st.markdown(
    "All support tickets created from unanswered questions."
)
st.markdown("---")

# Filters 
col1, col2, col3 = st.columns([3, 1, 1])
with col1:
    session_filter = st.text_input(
        "Filter by Session ID:",
        placeholder="Optional — paste session ID here",
        label_visibility="collapsed"
    )
with col2:
    show_all = st.checkbox("Show All", value=True)
with col3:
    refresh = st.button("🔄 Refresh", use_container_width=True)

# Load Tickets 
if refresh or True:
    params = {}
    if session_filter and not show_all:
        params["session_id"] = session_filter

    try:
        resp    = requests.get(
            f"{API_BASE_URL}/tickets",
            params=params,
            timeout=15
        )
        tickets = resp.json()

        if tickets:
            total    = len(tickets)
            open_t   = len([t for t in tickets if t["status"] == "Open"])
            high_p   = len([t for t in tickets if t["priority"] == "High"])
            resolved = len([t for t in tickets if t["status"] == "Resolved"])

            c1, c2, c3, c4 = st.columns(4)
            c1.metric("Total Tickets", total)
            c2.metric("Open",          open_t)
            c3.metric("High Priority", high_p)
            c4.metric("Resolved",      resolved)
            st.markdown("---")

            for ticket in tickets:
                p_color = (
                    "🔴" if ticket["priority"] == "High"
                    else "🟡" if ticket["priority"] == "Medium"
                    else "🟢"
                )
                s_color = (
                    "🟢" if ticket["status"] == "Resolved"
                    else "🟡" if ticket["status"] == "In Progress"
                    else "🔴"
                )
                with st.expander(
                    f"{p_color} #{ticket['id']} — "
                    f"{ticket['question'][:70]}... | "
                    f"{s_color} {ticket['status']}"
                ):
                    col_a, col_b = st.columns([3, 1])
                    with col_a:
                        st.markdown(f"**Question:** {ticket['question']}")
                        st.markdown(f"**Created:** {ticket['created_at']}")
                        st.markdown(
                            f"**Assigned To:** {ticket['assigned_owner']}"
                        )
                    with col_b:
                        st.markdown(
                            f"**Priority:** {p_color} {ticket['priority']}"
                        )
                        st.markdown(
                            f"**Status:** {s_color} {ticket['status']}"
                        )
                        if ticket.get("notion_url"):
                            st.markdown(
                                f"[🔗 Open in Notion]({ticket['notion_url']})"
                            )
        else:
            st.success(
                "🎉 No tickets yet! "
                "All questions answered from document library."
            )

    except Exception as e:
        st.error(f"Failed to load tickets: {str(e)}")

# Ticket Analytics 
st.markdown("---")
st.subheader("📊 Ticket Analytics")
st.caption("Priority distribution and daily ticket trends")

try:
    resp = requests.get(
        f"{API_BASE_URL}/tickets/analytics",
        timeout=5
    )
    if resp.status_code == 200:
        data = resp.json()

        c1, c2 = st.columns(2)
        with c1:
            st.metric("Total Tickets", data["total_tickets"])
        with c2:
            st.metric("Open Tickets",  data["open_tickets"])

        col_a, col_b = st.columns(2)

        with col_a:
            st.markdown("**Priority Distribution:**")
            priority = data.get("priority_distribution", {})
            if priority:
                pr_df = pd.DataFrame(
                    list(priority.items()),
                    columns=["Priority", "Count"]
                ).set_index("Priority")
                st.bar_chart(pr_df)
            else:
                st.info("No priority data yet!")

        with col_b:
            st.markdown("**Status Distribution:**")
            status = data.get("status_distribution", {})
            if status:
                for k, v in status.items():
                    color = (
                        "🟢" if k == "Resolved"
                        else "🟡" if k == "In Progress"
                        else "🔴"
                    )
                    st.markdown(f"{color} **{k}**: {v} tickets")
            else:
                st.info("No status data yet!")

        st.markdown("**Tickets Created — Last 7 Days:**")
        daily = data.get("daily_tickets", [])
        if daily:
            daily_df = pd.DataFrame(daily).set_index("date")
            st.line_chart(daily_df)
        else:
            st.info("No tickets in last 7 days!")

except Exception:
    st.info("Create tickets to see analytics here!")