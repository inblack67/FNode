import * as yup from 'yup';

export const registerSchema = yup.object().shape({
  name: yup.string().required('Name is required'),
  email: yup.string().email('Email is not valid').required('Email is required'),
  password: yup.string().required('Password is required'),
  username: yup.string().required('Username is required'),
});

export const loginSchema = yup.object().shape({
  username: yup.string().required('Username is required'),
  password: yup.string().required('Password is required'),
});
