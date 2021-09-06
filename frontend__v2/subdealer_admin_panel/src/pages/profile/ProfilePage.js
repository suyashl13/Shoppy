import React, { useContext, useEffect } from 'react'
import { toast } from 'react-toastify'
import AdminCoSubdealer from '../../components/profile_components/AdminCoSubdealer'
import SubdealerStaff from '../../components/profile_components/SubdealerStaff'
import { profileContext } from '../../contexts/ProfileContext'
import { getSubdealerProfile } from '../../helpers/BackendProfileHelper'
import { tConvert } from '../../helpers/DateTimeHelper'

export default function ProfilePage() {

    const { profile, setProfile } = useContext(profileContext)


    useEffect(() => {
        if (!profile) {
            getSubdealerProfile({
                onSuccess: (data) => {
                    console.log(data)
                    setProfile(data);
                },
                onError: (err) => {
                    toast('Unable to load profile.', { type: 'error' })
                }
            })
        }
    }, [])


    return (
        <div className='container'>
            <div className="row justify-content-center mt-5">
                {profile?.subdealer.is_active === false ?
                    <div className="alert alert-danger" role="alert">
                        Your subdealer profile has been deactivated by admin please contact authorities.
                    </div>
                    : null}
                <div className="col col-sm-12 col-lg-4 col-md-6 mb-4">
                    <small style={{ color: 'lightsteelblue' }}>Ref. Code</small>
                    <h3>{profile?.subdealer.subdealer_code}</h3>
                    <p className='mt-3' style={{ color: 'gray' }}>Delivering orders at : </p>
                    <ul className='list-group'>
                        {profile?.subdealer.pincodes.split(',').map((v, i) => <li key={i} className='list-group-item'>{v}</li>)}
                    </ul>
                </div>
                <div className="col col-sm-12 col-lg-8 col-md-6">
                    <h4>Subdealer Profile</h4>
                    <hr />
                    <div style={{ fontSize: '20px' }}>
                        Name : {profile?.user.name} <br />
                        Email : {profile?.user.email} <br />
                        Phone : {profile?.user.phone} <br />
                        Active : {profile?.subdealer.is_active === true ? 'Yes' : 'No'} <br />
                        Date Joined : {tConvert(profile?.user.date_time_created.split('+')[0].split('T')[1].split('.')[0])} ({tConvert(profile?.user.date_time_created.split('+')[0].split('T')[0])})
                    </div>
                    <br />
                    <h4>Staff</h4>
                    <hr />
                    <ul className='list-group'>
                        {
                            profile?.staff.map((v,i) => <SubdealerStaff key={i} staff={v}/>)
                        }
                    </ul>
                    <br />
                    {
                        profile?.user.is_admin_subdealer ? 
                            <>
                            <h4>Co-Subdealers</h4>
                            <hr />
                                <ul className="list-group">
                                    {profile?.co_subdealers.map((v,i) => <AdminCoSubdealer co_subdealer={v} key={i} />)}
                                </ul>
                            </>
                        : null
                    }
                </div>
            </div>
        </div>
    )
}

