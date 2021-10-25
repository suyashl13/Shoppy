import React, { useState } from 'react'
import { useContext } from 'react/cjs/react.development'
import ChannelPartnerTab from '../../components/users/ChannelPartnerTab';
import ClientTab from '../../components/users/ClientTab';
import StaffTab from '../../components/users/StaffTab';
import SubdealerTab from '../../components/users/SubdealerTab';
import { UserContext } from '../../contexts/UserContext'

export default function AllUserPage() {

    const { userList } = useContext(UserContext);
    const [activeTab, setActiveTab] = useState('clients')

    return (
        <div className='container mt-5'>
            <h2>All Users</h2>
            <hr />  
            <ul className="nav nav-pills nav-fill">
                <li className="nav-item">
                    <button className={activeTab === 'clients' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('clients') }} aria-current="page">Clients</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab === 'subdealers' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('subdealers') }} aria-current="page">Subdealers</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab === 'staff' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('staff') }} aria-current="page">Staff</button>
                </li>
                <li className="nav-item">
                    <button className={activeTab === 'channel_partners' ? 'nav-link active' : 'nav-link'} onClick={() => { setActiveTab('channel_partners') }} aria-current="page">Channel Partner</button>
                </li>
            </ul>
            <hr />
            {
                activeTab === 'clients' ? <ClientTab clients={userList?.filter(e => e.carts !== null)} />
                    : activeTab === 'subdealers' ? <SubdealerTab subdealers={userList?.filter(
                        e => (e.is_subdealer || e.is_admin_subdealer)
                    )} />
                        : activeTab === 'staff' ? <StaffTab staff={userList?.filter(e => e.is_subdealer_staff)} />
                            : activeTab === 'channel_partners' ? <ChannelPartnerTab channel_partners={userList.filter(e => e.is_channel_partner)} /> : <></>

            }
        </div>
    )
}
