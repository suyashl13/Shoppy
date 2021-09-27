import React, { useContext } from 'react'
import { Redirect, Route } from 'react-router'
import { loginContext } from '../../contexts/loginContext'

export default function ProtectedRoute({ component: Component, ...rest }) {
 
    const {isLoggedIn} = useContext(loginContext)

    console.log(isLoggedIn)

    return (
        <Route
            {...rest}
            render={
                () => {
                    if (isLoggedIn === null) {
                        return <center className='p-4'>
                            Loading...
                        </center>
                    } else if (isLoggedIn) {
                        return <Component/>
                    } else if (isLoggedIn === false) {
                        return <Redirect to='/login' />
                    }
                }
            }
        />
    )
}
