

import React from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import { animated, useSpring } from 'react-spring';

const Home = () => {

    const style = {
        height: '100vh',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
    }
    
  // useSpring hook to animate the title
  const fadeInTitle = useSpring({
    from: {
      opacity: 0,
      transform: 'translate3d(0, 40px, 0)',
      color: '#00b8d4',
      fontSize: '3em',
    },
    to: {
      opacity: 1,
      transform: 'translate3d(0, 0, 0)',
      color: '#00b8d4',
      fontSize: '3em',
    },
    config: { duration: 1000 },
    reset: true, // this will make the animation loop indefinitely
  });

  // useSpring hook to animate the welcome message
  const fadeInMessage = useSpring({
    from: {
      opacity: 0,
      transform: 'translate3d(0, 40px, 0)',
      color: 'rgba(255,255,255,0.75)',
      fontSize: '1.5em',
    },
    to: {
      opacity: 1,
      transform: 'translate3d(0, 0, 0)',
      color: 'rgba(255,255,255,0.75)',
      fontSize: '1.5em',
    },
    config: { duration: 1000 },
    reset: true, // this will make the animation loop indefinitely
  });

  return (
    <Container fluid className="bg-dark text-light text-center p-4" style = {style}>
      <Row>
        <Col>
          <animated.h1 style={fadeInTitle}>Monaco Game</animated.h1>
          <animated.p style={fadeInMessage}>
            Welcome to the ultimate gaming experience.
          </animated.p>
        </Col>
      </Row>
    </Container>
  );
};

export default Home;
