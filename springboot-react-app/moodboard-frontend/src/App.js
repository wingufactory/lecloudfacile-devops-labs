import React from 'react';
import FeedbackForm from './FeedbackForm';
import FeedbackDashboard from './FeedbackDashboard';
import { Container, Row, Col} from 'react-bootstrap';
import { Typography, Box, IconButton } from '@mui/material';
import { Feedback } from '@mui/icons-material';


const apiUrl = process.env.REACT_APP_API_URL;

console.log(apiUrl);
function App() {
    const handleFeedbackSubmit = (feedback) => {
        fetch(`${apiUrl}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(feedback),
        })
            .then(response => response.json())
            .then(data => {
                console.log('Success:', data);
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    };

    return (
        <Container fluid className="p-4">
            <Row>
                <Col md={4} className="mb-4">
                    <Typography variant="h4" gutterBottom>
                    What's your mood?
                    </Typography>
                    <FeedbackForm onSubmit={handleFeedbackSubmit} />
                </Col>
                <Col md={8} className="mb-8">
                <Box display="flex" alignItems="center" mb={4}>
                    <IconButton color="primary">
                        <Feedback fontSize="large" />
                    </IconButton>
                    <Typography variant="h4" component="h1" marginLeft={2}>
                        My Awesome Mood Board
                    </Typography>
                </Box>
                    <FeedbackDashboard />
                </Col>
            </Row>
        </Container>
    );
}

export default App;
