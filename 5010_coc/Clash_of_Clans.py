from datetime import datetime, timedelta
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import re

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///Clash_of_Clans.db'
db = SQLAlchemy(app)

# Models
class Team(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    team1_id = db.Column(db.Integer, db.ForeignKey('team.id'), nullable=False)
    event_time = db.Column(db.DateTime, nullable=False)
    team1 = db.relationship('Team', foreign_keys=[team1_id])

@app.route('/')
def index():
    now = datetime.now()
    events_from_db = Event.query.order_by(Event.event_time).all()

    processed_events = []
    for event_obj in events_from_db:
        if event_obj.event_time > now:
            remaining = event_obj.event_time - now
            days = remaining.days
            hours = remaining.seconds // 3600
            minutes = (remaining.seconds % 3600) // 60

            event_obj.duration_str_for_modal = f"{days}d {hours}h {minutes}m" if (days or hours or minutes) else ""
        else:
            event_obj.duration_str_for_modal = ""

        processed_events.append(event_obj)

    return render_template('index.html', upcoming_events=processed_events)

@app.route('/add-event', methods=['GET', 'POST'])
def add_event():
    if request.method == 'POST':
        team1_id = request.form['team1']
        duration = request.form['duration']
        days, hours, minutes = 0, 0, 0

        d_match = re.search(r'(\d+)\s*d', duration)
        h_match = re.search(r'(\d+)\s*h', duration)
        m_match = re.search(r'(\d+)\s*m', duration)

        if d_match: days = int(d_match.group(1))
        if h_match: hours = int(h_match.group(1))
        if m_match: minutes = int(m_match.group(1))

        event_time = datetime.now() + timedelta(days=days, hours=hours, minutes=minutes)
        event = Event(team1_id=team1_id, event_time=event_time)
        db.session.add(event)
        db.session.commit()
        return redirect(url_for('index'))

    teams = Team.query.order_by(Team.name).all()
    return render_template('event_form.html', teams=teams, action='Add')

@app.route('/teams', methods=['GET', 'POST'])
def manage_teams():
    if request.method == 'POST':
        name = request.form['name']
        team = Team(name=name)
        db.session.add(team)
        db.session.commit()
        return redirect(url_for('manage_teams'))
    teams = Team.query.order_by(Team.name).all()
    return render_template('team_manager.html', teams=teams)

@app.route('/delete-event/<int:id>', methods=['POST'])
def delete_event(id):
    event = Event.query.get_or_404(id)
    db.session.delete(event)
    db.session.commit()
    return redirect(url_for('index'))

@app.route('/delete-team/<int:id>', methods=['POST'])
def delete_team(id):
    team = Team.query.get_or_404(id)
    db.session.delete(team)
    db.session.commit()
    return redirect(url_for('manage_teams'))

@app.route('/edit-event/<int:event_id>', methods=['GET', 'POST'])
def edit_event(event_id):
    event = Event.query.get_or_404(event_id)

    if request.method == 'POST':
        duration = request.form['duration'].strip()
        days, hours, minutes = 0, 0, 0

        d_match = re.search(r'(\d+)\s*d', duration)
        h_match = re.search(r'(\d+)\s*h', duration)
        m_match = re.search(r'(\d+)\s*m', duration)

        if d_match: days = int(d_match.group(1))
        if h_match: hours = int(h_match.group(1))
        if m_match: minutes = int(m_match.group(1))

        event.event_time = datetime.now() + timedelta(days=days, hours=hours, minutes=minutes)
        db.session.commit()
        return redirect(url_for('index'))

    teams = Team.query.order_by(Team.name).all()
    duration = f"{(event.event_time - datetime.now()).days}d {((event.event_time - datetime.now()).seconds // 3600)}h {(((event.event_time - datetime.now()).seconds % 3600) // 60)}m"
    return render_template('event_form.html', event=event, teams=teams, action='Edit', duration=duration)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5010, debug=True)
