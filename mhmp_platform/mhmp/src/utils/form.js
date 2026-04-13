import { showErrorMessage } from '@/utils/error'

export async function validateElForm(formRef, fallback = '请先完善必填项后再继续') {
  const form = formRef?.value || formRef
  if (!form?.validate) {
    return true
  }
  try {
    await form.validate()
    return true
  } catch (error) {
    showErrorMessage(error, fallback)
    return false
  }
}
