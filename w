import streamlit as st
from reportlab.pdfgen import canvas
import openai

# إعداد مفتاح OpenAI
openai.api_key = "أدخلي_مفتاح_API_الخاص_بك"

# وظيفة لتوليد الخطة العلاجية باستخدام OpenAI
def generate_plan(data):
    prompt = f"""
    طفل عمره {data['age']} سنة يعاني من {data['issues']}. 
    الوضع الأسري: {data['family_status']}. 
    الحالة الاقتصادية: {data['economic_status']}. 
    قدم خطة علاجية مقسمة إلى ذاتية وبيئية.
    """
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices[0].text.strip()

# وظيفة لتصدير التقرير كـ PDF
def export_pdf(data, plan):
    file_name = f"خطة_علاجية_{data['name']}.pdf"
    c = canvas.Canvas(file_name)
    c.drawString(100, 750, f"اسم الطفل: {data['name']}")
    c.drawString(100, 730, f"العمر: {data['age']}")
    c.drawString(100, 710, f"المشكلة: {data['issues']}")
    c.drawString(100, 690, "الخطة العلاجية:")
    c.drawString(100, 670, plan)
    c.save()
    return file_name

# واجهة المستخدم باستخدام Streamlit
st.title("نظام توليد خطط علاجية للأطفال")

# إدخال البيانات
data = {}
data['name'] = st.text_input("اسم الطفل")
data['age'] = st.number_input("عمر الطفل", min_value=1, max_value=18, step=1)
data['issues'] = st.text_area("ما هي المشاكل التي يعاني منها الطفل؟")
data['family_status'] = st.selectbox("الوضع الأسري", ["متزوجين", "منفصلين"])
data['economic_status'] = st.selectbox("الوضع الاقتصادي", ["ضعيف", "متوسط", "جيد"])

if st.button("توليد خطة علاجية"):
    if all(data.values()):
        # توليد الخطة
        plan = generate_plan(data)
        st.subheader("الخطة العلاجية:")
        st.write(plan)

        # تصدير التقرير
        if st.button("تصدير التقرير كـ PDF"):
            file_name = export_pdf(data, plan)
            st.success(f"تم تصدير التقرير: {file_name}")
    else:
        st.error("يرجى إدخال جميع البيانات.")
