import { stringify } from 'qs'
import React, { useContext, useState } from 'react'
import { useParams } from 'react-router'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { BASE_URL } from '../../Config'
import { profileContext } from '../../contexts/ProfileContext'

export default function StaffSlugPage(props) {

    const { profile, setProfile } = useContext(profileContext)
    const { id } = useParams();
    const staff_profile = profile?.staff.filter(val => val.id == id)[0];
    const [isLoading, setIsLoading] = useState(false)


    if (!staff_profile) {
        return <center className='pt-5 text-lg'>Something went wrong! Please go back and <Link className='text-primary' to='/profile'>Try again</Link> or wait.</center>
    }


    const updateStaffActivationStatus = async (staffStatus) => {
        setIsLoading(true)
        await fetch(`${BASE_URL}users/subdealers/staff/${id}/`, {
            method: 'PUT',
            headers: {
                'Authorization': localStorage.getItem('jwt'),
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: stringify(staffStatus)
        }).then(async (e) => {
            const updatedStaff = await e.json()
            if (e.status === 200) {
                let updatedStaffArray = profile?.staff.map(
                    (item) => { if (item.id == id) { return updatedStaff } else { return item } })
                setProfile({ ...profile, staff: updatedStaffArray })
                setIsLoading(false)
            } else {
                toast(updatedStaff.ERR, { type: 'error' })
                setIsLoading(false)
            }

        })
            .catch(err => {
                toast('Unable to update staff status.', { type: 'error' })
                console.log({ err })
                setIsLoading(false)
            })
    }

    return (
        <div className='container pt-5'>
            <h3>#{staff_profile?.id} {staff_profile?.name}</h3>
            <hr />
            <table className="table table-bordered">
                <thead>
                    <tr>
                        <th scope="col">Name</th>
                        <td>{staff_profile?.name}</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="col">Email</th>
                        <td>{staff_profile?.email}</td>
                    </tr>
                    <tr>
                        <th scope="col">Phone</th>
                        <td>{staff_profile?.phone}</td>
                    </tr>
                    <tr>
                        <th scope="col">Address</th>
                        <td>{staff_profile?.address}</td>
                    </tr>
                    <tr>
                        <th scope="col">Pincode</th>
                        <td>{staff_profile?.pincode}</td>
                    </tr>
                    <tr>
                        <th scope="col">Active</th>
                        <td className='d-flex justify-content-between'><center>{staff_profile?.is_active ? 'Active' : 'Deactivated'}</center> <button
                            disabled={isLoading}
                            className={isLoading ? 'btn btn-sm btn-secondary' : staff_profile?.is_active ? 'btn btn-sm btn-danger' : 'btn btn-sm btn-success'}
                            onClick={e => { updateStaffActivationStatus({is_active: !staff_profile?.is_active }) }}>{
                                isLoading ? <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> :
                                    staff_profile?.is_active ? 'Deactivate' : 'Activate'}
                        </button></td>
                    </tr>
                </tbody>
            </table>
        </div>
    )
}
