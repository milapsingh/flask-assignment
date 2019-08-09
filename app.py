from flask import Flask
from flask import Flask, flash, redirect, render_template, request, session, abort
import mysql.connector
import os
import logging


app = Flask(__name__)
@app.route('/')
def home():
    return render_template('home.html')
@app.route('/add_data', methods=['GET','POST'])
def add_data():
    status = add_detail()
    if status != 'success':
        return render_template('add_data.html')
    else:
        return render_template('home.html')
@app.route('/search', methods=['GET','POST'])
def search():
    if request.method == 'POST':
        status = search_detail()
        print ("hello", status)
        if status != None:
            return render_template('result.html', status = status)
        else:
            return render_template('search.html')
    else:
        return render_template('search.html')
def add_detail():
    print("entered")
    cnx = mysql.connector.connect(host='XXXXXXXXXX',user='admin',password='password', database='assignment')
    cursor = cnx.cursor()
    try:
        name = request.form['name']
        address = request.form['address']
        mobile = request.form['mobile']
        print (name,address,mobile)
        print(type(name), type(address), type(mobile))
        add_detail = ("INSERT INTO assignment "
                        "(name, address, mobile) "
                        "VALUES (%s, %s, %s)")
                        #"VALUES ('test', 'test', 12234)")
        print(add_detail)
        data_employee = (name, address, mobile)
        cursor.execute(add_detail, data_employee)
        #cursor.execute(add_detail)
        print("122")
        cnx.commit()
        cursor.close()
        cnx.close()
        print("closed everythging") #'success'
        return 'success'
    except Exception as e:
        return(str(e))
def search_detail():
    cnx = mysql.connector.connect(host='XXXXXXXXXX',user='admin',password='password', database='assignment')
    cursor = cnx.cursor()
    try:
        name = request.form['name']
        query = """SELECT name, address, mobile FROM assignment WHERE name=%s"""
        cursor.execute(query, (name, ))
        data=cursor.fetchall()
        cursor.close()
        cnx.close()
        return data
    except Exception as e:
        return(str(e))
if __name__ == "__main__":
    import logging
    logging.basicConfig(filename='error.log',level=logging.DEBUG)
    app.secret_key = os.urandom(12)
    app.run(debug=True, host='0.0.0.0')
