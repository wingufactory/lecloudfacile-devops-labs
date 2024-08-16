import React, { useState } from 'react';

import { ListGroup, Form, Button } from 'react-bootstrap';
import { TextField, Typography, Rating } from '@mui/material';

function FeedbackForm({ onSubmit }) {
    const [userName, setUserName] = useState('');
    const [comments, setComments] = useState('');
    const [rating, setRating] = useState(5);

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit({ userName, comments, rating });
        setUserName('');
        setComments('');
        setRating(5);
    };

    return (
        <Form onSubmit={handleSubmit}>
            <Form.Group controlId="formName" className="mb-3">
              <TextField
                label="Your Name"
                variant="outlined"
                fullWidth
                value={userName}
                onChange={(e) => setUserName(e.target.value)}
                required
              />
            </Form.Group>
            <Form.Group controlId="formComment" className="mb-3">
              <TextField
                label="What's your feeling?"
                variant="outlined"
                fullWidth
                value={comments}
                onChange={(e) => setComments(e.target.value)}
                multiline
                rows={4}
              />
            </Form.Group>
            <Form.Group controlId="formRating" className="mb-3">
              <Typography component="legend">Appreciate your feeling</Typography>
              <Rating
                name="rating"
                value={rating}
                onChange={(event, newValue) => {
                  setRating(newValue);
                }}
              />
            </Form.Group>
            <Button variant="primary" type="submit" className="w-100">
              Submit
            </Button>
        </Form>
    );
}

export default FeedbackForm;
