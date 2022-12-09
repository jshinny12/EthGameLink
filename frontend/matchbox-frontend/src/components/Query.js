import React from 'react'
import { Form, Button } from 'react-bootstrap'




const Query = () => {   
    const style = {
      margin: 'auto',
      opacity: '0.7',
      width: '20%',
      padding: '10px',
      border: '1px solid black',
      borderRadius: '5px',
      backgroundImage: 'linear-gradient(to right, #e6f2ff, #ffffff)',
      boxShadow: '0 0 10px 0 rgba(0,0,0,0.5)',
      marginTop: '10px',
      marginBottom: '10px',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      flexDirection: 'column',
      gap: '10px',
    }

    const divstyle = {
      backgroundImage: 'url(https://c4.wallpaperflare.com/wallpaper/374/240/31/ferrari-formula-1-race-cars-monaco-wallpaper-preview.jpg)',
      backgroundSize: 'cover',
      backgroundRepeat: 'no-repeat',
      height: '100vh',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      size: 'lg',
    }
  return (
    <div style = {divstyle}>
    <Form style = {style}>
        <Form.Group controlId="formBasicEmail">
            <Form.Label>Search: </Form.Label>
            <Form.Control type="text" placeholder="Enter Race ID" />
        </Form.Group>
        <Button variant="primary" type="submit">
            Submit
        </Button>
    </Form>
    </div>
    
  )
}

export default Query