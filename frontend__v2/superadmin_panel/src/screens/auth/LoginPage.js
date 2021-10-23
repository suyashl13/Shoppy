import React, { useContext, useState } from 'react'
import { useHistory } from 'react-router'
import { LoginContext } from '../../contexts/AuthContext'
import { loginAtBackend } from '../../helpers/BackendAuthHelper'

export default function LoginPage() {

    const history = useHistory()
    const { setIsLoggedIn } = useContext(LoginContext);
    const [credentials, setCredentials] = useState({
        phone: '',
        password: '',
    })

    const login = () => {
        loginAtBackend(credentials, {
            onSuccess: (res) => {
                setIsLoggedIn(true);
                history.push('/')
            },
            onError: (err) => {
                console.error(err);
            },
        })
    }

    return (
        <div className='container'>
            <form className='p-5' onSubmit={
                (e) => {
                    e.preventDefault();
                    login();
                }
            } >
                <input required type='number' value={credentials.phone} onChange={e => { setCredentials({ ...credentials, phone: e.target.value }) }} className='form-control' placeholder='Phone'></input>
                <input required type='password' value={credentials.password} onChange={e => { setCredentials({ ...credentials, password: e.target.value }) }} className='form-control mt-2' placeholder='Password'></input>
                <button type='submit' className='btn btn-dark btn-sm mt-2'>Submit</button>
            </form>
            {JSON.stringify(credentials)}
        </div>
    )
}
