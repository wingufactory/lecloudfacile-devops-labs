import React, { useEffect, useState } from 'react';

import { Row, Col, ListGroup, Form, Button, Image} from 'react-bootstrap';
import { TextField, Typography, Rating, Avatar } from '@mui/material';

const apiUrl = process.env.REACT_APP_API_URL;

console.log(process.env.REACT_APP_API_URL);

console.log(apiUrl);

function FeedbackDashboard() {
    const [feedbackList, setFeedbackList] = useState([]);

    const fetchData = async () => {
        try {
          const response = await fetch(`${apiUrl}`);
          const data = await response.json();
          setFeedbackList(data);
        } catch (error) {
          console.error('Error fetching feedback data:', error);
        }
    };

    useEffect(() => {
        fetchData(); // Initial fetch
    
        const intervalId = setInterval(() => {
          fetchData();
        }, 5000); // Refresh every 5 seconds
    
        return () => clearInterval(intervalId); // Cleanup interval on component unmount
      }, []);


    const averageRating = () => {
        const total = feedbackList.reduce((acc, feedback) => acc + feedback.rating, 0);
        return (total / feedbackList.length).toFixed(2);
    };

    return (

        <Row>
            <Col md={12} className="mb-12">
            <Typography variant="h5" gutterBottom> Mood Average </Typography><Rating name="read-only" value={feedbackList.length ? averageRating() : '0'} readOnly /> 
           
                <hr></hr>
                <br></br> <br></br>
                <ListGroup>
                    {feedbackList.length === 0 ? (
                        <ListGroup.Item>No feedback yet.</ListGroup.Item>
                        ) : (
                        feedbackList.map((fb, index) => (
                            <ListGroup.Item key={index} className="d-flex align-items-start">
                            <Avatar alt={fb.userName} src=""className="me-3" />
                            <div>
                                <Typography variant="h6" className="mb-0">{fb.userName}</Typography>
                                <Rating name="read-only" value={fb.rating} readOnly />
                                <Typography variant="body2">{fb.comments}</Typography>
                            </div>
                            </ListGroup.Item>
                        ))
                    )}
                </ListGroup>
            </Col>
        </Row>
    );
}

export default FeedbackDashboard;
