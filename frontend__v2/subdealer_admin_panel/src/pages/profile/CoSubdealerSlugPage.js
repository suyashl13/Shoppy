import React, { useContext } from 'react'
import { useParams } from 'react-router'
import { Link } from 'react-router-dom'
import { profileContext } from '../../contexts/ProfileContext'
import { tConvert } from '../../helpers/DateTimeHelper'

export default function CoSubdealerSlugPage() {

    const { id } = useParams()
    const { profile, setProfile } = useContext(profileContext)
    const co_subdealer = profile?.co_subdealers.filter(ele => ele.id == id)[0];


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
                        <td className={co_subdealer.is_active ? 'text-success' : 'text-danger'}>{co_subdealer.is_active ? 'Activated' : 'Disabled'}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    )
}
