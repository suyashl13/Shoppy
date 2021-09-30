import React, { useContext } from 'react'
import { useState } from 'react'
import { useHistory } from 'react-router';
import { toast } from 'react-toastify';
import { loginContext } from '../../contexts/loginContext';
import { loginAtBackend } from '../../helpers/BackendAuthHelpers';

export default function LoginPage() {

    const [loginCredentials, setLoginCredentials] = useState({ phone: '', password: '' });
    const { setIsLoggedIn } = useContext(loginContext);
    const history = useHistory()

    const login = async () => {
        await loginAtBackend({
            onSuccess: () => {
                setIsLoggedIn(true);
                history.push('/')
            },
            onError: (err) => {
                console.log(err.err.response.data.ERR)
                if (err.err.response.data.ERR) {
                    toast(err.err.response.data.ERR, { type: 'error' });
                } else
                toast("Unable to perform login", { type: 'error' });
            }
        }, loginCredentials)
    }

    return (
        <div className='container'>
            <div className="card mt-5 p-4 rounded">
                <h3 className='text-dark'>Login as Channel Partner</h3>
                <hr />
                <form onSubmit={async e => { e.preventDefault(); login() }}>
                    <input required type="number" placeholder='Phone'
                        value={loginCredentials.phone}
                        onChange={e => { setLoginCredentials({ ...loginCredentials, phone: e.target.value }) }}
                        className="form-control mt-2" />
                    <input required type="password" placeholder='Password'
                        value={loginCredentials.password}
                        onChange={e => { setLoginCredentials({ ...loginCredentials, password: e.target.value }) }}
                        className="form-control mt-2" />
                    <button type='submit' className='btn btn-dark mt-4'>Login</button>
                </form>
            </div>
        </div>
    )
}
