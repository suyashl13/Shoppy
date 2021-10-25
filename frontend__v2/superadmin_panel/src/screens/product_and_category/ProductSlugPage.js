import React, { useState } from 'react'
import { useParams } from 'react-router'
import { Link } from 'react-router-dom'
import { toast } from 'react-toastify'
import { useContext } from 'react/cjs/react.development'
import { ProductContext } from '../../contexts/ProductContext'
import { updateProductAtBackend } from '../../helpers/BackendProductAndCategoryHelper'

export default function ProductSlugPage() {

    const { product_id } = useParams()
    const { productAndCategoryList, setProductAndCategoryList } = useContext(ProductContext)

    const kProduct = productAndCategoryList?.products?.filter((ele) => ele.id == product_id)[0]

    console.log(kProduct)

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
                        <td>{kProduct?.addedby_subdealer?.user?.name ? <Link
                            className='text-decoration-none'
                            to={`/subdealer/${kProduct?.addedby_subdealer?.id}`}>
                            {kProduct?.addedby_subdealer?.user?.name + ` (${kProduct?.addedby_subdealer.subdealer_code})`}</Link> : 'No Information'}</td>
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
                        <td className='d-flex justify-content-between'
                        >{kProduct?.is_active ? 'Yes' : 'No'} <EditProductStatusButton product={kProduct} productAndCategoryList={productAndCategoryList} setProductAndCategoryList={setProductAndCategoryList} /> </td>
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

const EditProductStatusButton = ({ product, productAndCategoryList, setProductAndCategoryList }) => {

    const [isLoading, setisLoading] = useState(false)

    function updateProduct(updateObject) {
        setisLoading(true)
        updateProductAtBackend(product?.id, updateObject, {
            onSuccess: ({ data }) => {
                const updatedProductList = productAndCategoryList?.products?.map(e => {
                    if (e.id == data.id) {
                        console.log(data)
                        return data;
                    } else
                        return e;
                })
                setProductAndCategoryList({ ...productAndCategoryList, products: updatedProductList });
                toast('Successfully updated product', { type: 'info' })
                setisLoading(false)
            },
            onError: () => {
                toast("Unable to update object.", { type: 'error' })
                setisLoading(false)
            }
        })
    }

    return <button className={!product?.is_active ? 'btn btn-sm btn-success m-1' : 'btn btn-sm btn-danger m-1'}
        disabled={isLoading}
        onClick={() => updateProduct({ is_active: !product?.is_active })}
    >{isLoading ? 'Loading...' : !product?.is_active ? 'Activate' : 'Deactivate'}</button>
}