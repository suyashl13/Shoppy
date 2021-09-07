import { stringify } from 'qs'
import React, { useContext } from 'react'
import { useParams } from 'react-router'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { useState } from 'react/cjs/react.development'
import { BASE_URL } from '../../Config'
import { profileContext } from '../../contexts/ProfileContext'
import { tConvert } from '../../helpers/DateTimeHelper'

export default function CoSubdealerSlugPage() {

    const { id } = useParams()
    const { profile, setProfile } = useContext(profileContext)
    const co_subdealer = profile?.co_subdealers.filter(ele => ele.id == id)[0];
    const [isLoading, setIsLoading] = useState(false)

    const updateSubdealerActivationStatus = async (coSubdealerStatus) => {
        setIsLoading(true)
        await fetch(`${BASE_URL}users/subdealers/${co_subdealer?.user.id}/`, {
            method: 'PUT',
            headers: {
                'Authorization': localStorage.getItem('jwt'),
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: stringify(coSubdealerStatus)
        }).then(async (e) => {
            const updatedSubdealer = await e.json()
            console.log(updatedSubdealer)
            if (e.status === 200) {
                let updatedSubdealerArray = profile?.co_subdealers.map(
                    (item) => { if (item.id == id) { return updatedSubdealer } else { return item } })
                setProfile({ ...profile, co_subdealers: updatedSubdealerArray })
                setIsLoading(false)
            } else {
                toast(updatedSubdealer.ERR, { type: 'error' })
                setIsLoading(false)
            }

        })
            .catch(err => {
                toast('Unable to update staff status.', { type: 'error' })
                console.log({ err })
                setIsLoading(false)
            })
    }


    if (!co_subdealer) {
        return <center className='p-5'>Something went wrong!!. <Link to='/profile'>Try Again</Link></center>
    }

    return (
        <div className='container pt-5'>
            <h3>#{co_subdealer.user.id} - {co_subdealer.user.name}</h3>
            <hr />
            <table className="table table-bordered">
                <tbody>
                    <tr>
                        <th scope="col">Email</th>
                        <td>{co_subdealer.user.email}</td>
                    </tr>
                    <tr>
                        <th scope="col">Phone</th>
                        <td>{co_subdealer.user.phone}</td>
                    </tr>
                    <tr>
                        <th scope="col">Address</th>
                        <td>{co_subdealer.user.address}</td>
                    </tr>
                    <tr>
                        <th scope="col">Pincode</th>
                        <td>{co_subdealer.user.pincode}</td>
                    </tr>
                    <tr>
                        <th scope="col">Date Time Created</th>
                        <td>{tConvert(co_subdealer.user.date_time_created.split('+')[0].split('T')[1].split('.')[0])} ({tConvert(co_subdealer.user.date_time_created.split('+')[0].split('T')[0])})</td>
                    </tr>
                    <tr>
                        <th scope="col">Subdealer Code </th>
                        <td>{co_subdealer.subdealer_code}</td>
                    </tr>
                    <tr>
                        <th scope="col">Activation </th>
                        <td className={co_subdealer.is_active ? 'text-success d-flex justify-content-between' : 'text-danger d-flex justify-content-between'}>{co_subdealer.is_active ? 'Activated' : 'Disabled'}
                        
                        <button
                            disabled={isLoading}
                            className={isLoading ? 'btn btn-sm btn-secondary' : co_subdealer?.is_active ? 'btn btn-sm btn-danger' : 'btn btn-sm btn-success'}
                            onClick={e => { updateSubdealerActivationStatus({is_active: !co_subdealer?.is_active }) }}>{
                                isLoading ? <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> :
                                    co_subdealer?.is_active ? 'Deactivate' : 'Activate'}
                        </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    )
}
