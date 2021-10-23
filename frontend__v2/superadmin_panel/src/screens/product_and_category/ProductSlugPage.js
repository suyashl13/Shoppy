import React from 'react'
import { useParams } from 'react-router'
import { useContext } from 'react/cjs/react.development'
import { ProductContext } from '../../contexts/ProductContext'

export default function ProductSlugPage() {

    const { product_id } = useParams()
    const { productAndCategoryList, setProductAndCategoryList } = useContext(ProductContext)

    const kProduct = productAndCategoryList?.products?.filter((ele) => ele.id == product_id)[0]

    return (
        <div className='container mt-5'>
            <center>
                <img src={kProduct?.product_image} alt="product_image" className="mt-4 rounded-circle mb-5" height='240' width='238' alt={kProduct?.title} />
            </center>

            <table className='table table-hover'>
                <tbody>
                    <tr>
                        <th>Product Name</th>
                        <td>{kProduct?.title}</td>
                    </tr>
                    <tr>
                        <th>Price</th>
                        <td>Rs. {kProduct?.price}</td>
                    </tr>
                    <tr>
                        <th>Description</th>
                        <td>{kProduct?.description}</td>
                    </tr>
                    <tr>
                        <th>Category</th>
                        <td>{kProduct?.category ? kProduct?.category : "No Information"}</td>
                    </tr>
                    <tr>
                        <th>Subdealer</th>
                        <td>{kProduct?.addedby_subdealer?.user?.name ? kProduct?.addedby_subdealer?.user?.name + ` (${kProduct?.addedby_subdealer.subdealer_code})` : 'No Information'}</td>
                    </tr>
                    <tr>
                        <th>Available Stock</th>
                        <td>{kProduct?.available_stock} Unit(s)</td>
                    </tr>
                    <tr>
                        <th>Available to Sale</th>
                        <td>{kProduct?.is_available ? 'Yes' : 'No'}</td>
                    </tr>
                    <tr>
                        <th>Active</th>
                        <td>{kProduct?.is_active ? 'Yes' : 'No'}</td>
                    </tr>
                    <tr>
                        <th>Tax</th>
                        <td>{kProduct?.tax_percentage}%</td>
                    </tr>
                    <tr>
                        <th>Discount</th>
                        <td>{kProduct?.discount}%</td>
                    </tr>
                    <tr>
                        <th>Base Price</th>
                        <td>Rs. {kProduct?.base_price}</td>
                    </tr>
                    <tr>
                        <th>Date Created</th>
                        <td>{kProduct?.date_time_created.split('.')[0].split('T')[0]}</td>
                    </tr>
                </tbody>
            </table>

        </div>
    )
}
