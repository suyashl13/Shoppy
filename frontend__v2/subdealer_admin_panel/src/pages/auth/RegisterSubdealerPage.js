import React, { useState } from 'react'
import { Redirect } from 'react-router-dom'
import { toast } from 'react-toastify'
import { createSubdealerAccAtBackend } from '../../helpers/BackendAuthHelper'

export default function RegisterSubdealerPage({ history }) {

    const [formData, setFormData] = useState({
        name: '',
        email : '',
        phone : '',
        address : '',
        pincode : '',
        password : '',
        confPassword : '',
        ref_code : '',
    })

    if (localStorage.getItem('jwt')) {
        return <Redirect to='/' />
    }

    return (
        <div className='container mb-5 mt-5'>
            <div className='p-4'>
                <center><h3>
                    {'Register as Subdealer'.toUpperCase()}
                </h3></center>

                <form className='p-4 mt-5 border rounded' onSubmit={e => {
                    e.preventDefault()
                    if (formData.password !== formData.confPassword) {
                        toast('Password confirmation failed', {type:"error"})
                        setFormData({...formData, password:'', confPassword: ''});
                        return;
                    }
                    createSubdealerAccAtBackend({
                        regFormData : formData,
                        onSuccess: () => {
                            history.push('/')
                            window.location.reload();
                        },
                        onError: (err) => {
                            if (err.err.response?.data.ERR) {
                                toast(err.err.response?.data?.ERR, {type :'error'})
                            } else {
                                toast("Unable to create an account.", {type :'error'})
                            }
                        }
                    });
                }}>
                    <div className="mb-3">
                        <label htmlFor="name-input" className="form-label">Full Name</label>
                        <input type="text" className="form-control" value={formData.name} onChange={e=>{setFormData({...formData, name : e.target.value})}} id="name-input" maxLength='30' required />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="email-input" className="form-label">Email</label>
                        <input type="email" className="form-control" value={formData.email} onChange={e=>{setFormData({...formData, email : e.target.value})}} id="email-input" aria-describedby="emailHelp" maxLength='50' required />
                        <div id="emailHelp" className="form-text">We'll never share your email with anyone else.</div>
                    </div>
                    <div className="mb-3">
                        <label htmlFor="phone-input" className="form-label">Phone Number</label>
                        <input type="number" className="form-control" id="phone-input" aria-describedby="phoneHelp" value={formData.phone} onChange={e=>{setFormData({...formData, phone:e.target.value})}} required maxLength='10' />
                        <div id="phoneHelp" className="form-text">We'll never share your phone with anyone else.</div>
                    </div>
                    <div className="mb-3">
                        <label htmlFor="ref-input" className="form-label">Reference Code</label>
                        <input type="text" className="form-control" id="ref-input" value={formData.ref_code} onChange={e=>{setFormData({...formData, ref_code:e.target.value.toUpperCase()})}} maxLength='8' />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="address-input" className="form-label">Address</label>
                        <textarea className="form-control" value={formData.address} onChange={e=>{setFormData({...formData, address : e.target.value})}}  id="name-input" maxLength='150' required />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="pincode-input" className="form-label">Pincode</label>
                        <input type="number" className="form-control" value={formData.pincode} onChange={e=>{setFormData({...formData, pincode : e.target.value})}} id="pincode-input" maxLength='6' required />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="password-input" className="form-label">Password</label>
                        <input type="password" className="form-control" value={formData.password} onChange={e=>{setFormData({...formData, password : e.target.value})}} id="password-input" required />
                    </div>
                    <div className="mb-3">
                        <label htmlFor="c-password-input" className="form-label">Confirm Password</label>
                        <input type="password" className="form-control" value={formData.confPassword} onChange={e=>{setFormData({...formData, confPassword : e.target.value})}} id="c-password-input" required />
                    </div>

                    <button type="submit" className="btn btn-primary mt-3">Register as Subdealer</button>
                </form>
            </div>
        </div>
    )
}
