#!/bin/bash
#
# Author: fatimazq (Fatimah Azzahra)
# GitHub: https://github.com/fatimazq
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��k�Z$b~�����؊��$�䡉w|h��P�ރ}9V�WC3�ϋ�֮h�N�E�8�2T/D���F=��[7رm!٘����-f*�z;�p��Ǖ�/a��8�b�Ԉ��0^g&ВN$��F���l~?e�oJd�&�2�7����Yފ�6CJ
�&�i�C��Ot���꺼L��dF���D>6fr�6@J��m�k��WGy�{��+k�`R]�h��d�5G�D�4R�g��VM��Vt94"u_8��J��Ρw��*+�Lo�]�(�\�zG�!C�%m�am	p����S�r(�EOR�*�FQ�������yn~Z����Toˣq�,ﰧg�@���h��u7/ҴF�_8�7���ύ�]XĂ�r=�YM�����VٷHBV�(A9q]�Sk��gK�eS�M�^6K���c[��vlc��ݞ�8ut��~�A����	��Tt�u�.�֬�� ���/[�8��{tS��'[g���b�	6��8N4G�u��jV���	[a�dY�M��j�Cm��~�-_E}!�$g���P,AC��K,u��FЕ��ǃ���r$Twη�\*����R�^j���oBmTg���=�ٜ���5��>~������g�[�-�[j`��8
)��%�A�=�5}EMLs���1��d6�4� �+�4_��-OV8}�=���y��Z1kR��L'k��.��;:2�GV��k�g�=8yF��_�+4���n�[�6��Ȩ�!��pw�](|ًP�]=E,�g��%��(*T����#�_� ��Ɛ��t��"��?ˁ��zx#�r�kԊA%I�7�j�K����SIU�D�DM�=�ߧ���)�܂��\������� �H�O;y�}��8��Rΐ|�c� �pa�!^D�1��0Q�0 N��yX������xl5Kj��P.G9*��)X�06�F&C"�WI;F��l^2L�K���R�;w�V��x �TD�� �ދ�ȸʣֳWX_ /��
;rA/�#̃1AeR�bk#!��j����Y����'R�߂��IDv�S�X8�-����&����P�eAͨ\nzG��# :��ipU�Xڥ/@Fk�C6��x�G�\���X'�����թ���\��oD����$̢�:үޣ����;^�*V]C���
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��=��6����!,��Y�u�t�s$���u��Э+�S�<�|�Ѕ�l���_�k�-~�v��?c+��<�L���	�e|����v��ԡ�<��
خ5R��%C���yu�2yB�Lؽ[�c�S^�&��FOd��z}:^���X�;��͓j�c�'�Gv̉�|c�.��11}�8H���s79V.D��\��oq%��HT�+st��ˤ����D�.��:��NB��h/�o�s���҇K���じ�H�Q6�@�`%��A�E+e��Ә�\��}���H.R2���j%��q�t,�WB��?��]����`𓲨O)�F�����>r��2���Q|E	/���swrIsm��S��\D��7���ǽ�x�W�P��"��r��s��l�OEvh���)��g �$)B�D�B���ȍ��uäC���OGP"��zi߾�`�QqdzG��~��S�(�E_�,A�7���u�fHn(#I�ŝhH��m�TLVLs�1d�&6��Q4�ʋ��|,�(�V=��e1\N���yC�d4BHQX��)�Ob���%'�i���K�~r��.�V���'��5�gо2uxN4�&�`w(b�Q
|�)����g��G�Xnc���>ל��G�hԜ����T����`M�t0�Nj��9cp!�f�({�,�+��?Y����̗ X�m��QO���0FZ���d�uM��5c�h�\䡹ܞ	m$=�����MBn� q	]ʕp��(ڏ�A� ��rc19y?X�P�>�R�A�'��J�-�I�?�l����[!ۆ���,��_Q�},Y��"����7'��0�F�53A�Y�Kܤ�m��)�-��/��.����,��,ζ�oY^�h�ŷI@^��T|��,�7'_?>pʚ����2Xv�tX6[.��K)o0���Z���x� (XX�𺴧�w��E9��r��7q��ee[�f)mWĀR����2�xSK�E��7G
8��dTY��w�m�<��4f�9+&"���F�W7��Uҟ"C�|�H�j��|�"]���O����㆜�1�;S㍋6��fom{����������Ij��� �-�IR�g��@�̠e��D�u�}Y������(Uq�#!E�����13k��-��g�%R���z�p�~�g�;�)�:��A0�H:\8G�=��
f�_\e����>�$�MV������ͫI��\�yڮ�Qs��1�l�zG�����M������y���o����zW�%�1�	J R	��MFe�y�gNS���
-���W'0�c�@��i-�b?��9�\G��m���_t r�J�&��H�z١��qd�G�%� �c}�~{���Vx:j�l|��m9���ե�Q��iͤw�P�璝[h���J1�ݸ�C��8e������7恰��'��Vo��.;�"��*BzF�6��=X�X_��^�鐈\���㓠v����8�2�����2��җ���Q�y�0��*��)�,�0s�ۭf��D��0��@���ELS��J�vR-	�%����;���cP5��s(y+��-�1Z�=�&ΰ����િ^S����٤�;��I����cDQ���%���h���pG{F�.p5Ǣ���W{�|���1�b��(e��l^����c>A�����|���V�ߧw�'�]���ɤ�'�<^}_YA��5<.��_I�u-땽x��2P�,u� �$�ǸF��^�������(�f������ʿ��^�{{G�^���5X�V���<D;^m��A�!
p0@np8_A��fJ�<��7�$�[�HA�Ҟ;u��5g�;�ۧ��n�^],N�.���i��Ejg�(���F�-���O�6h��sr!�f��PJ��;T`��8L�fQD��<6�	Q�G6��Tm�d��~��;3j�b��})k���x`C3{Ǵ��QJ��5�t5�ǰk�?s����xp|�y[����������w��^&��,Fyx�髡JH�~'�z]o3z��ؙ:�.L͇Ti,W�G��6>&�>�q�<&��6{�kQ�YO��,��)����*��e�m��.���!G�=kI3B#$`�
����f�?���Û��ͶZ�;��*QhMg�e����gƦl�Y6M�"�m��z�x,�$�`����0Қ��qI������{�=�	�a}�h��Z���%
� �df�#��-�V�SnIji�1�7!@�*�����1�6�n$aV�uEG�%_��H��|WA�%�M�S$ZR<�����{G�*��j����o�N�.z�*�>�Mi|!$�u��?5d+X�^�v �h1��a*Dy^�X�IY��k��H�>��bt��!)�>����HneB$���������.�j�f�4&�N/19�ѽ�y����n�O�20q�:���%�(Ɯ5%_�t*�CP�<� ,A[RU��'��C&��'�T�����D{�G�[�ɓû/4�$v|ap
�l���Kd���,�vJ�i�m�q��
J�unL��G�M'6�uT=�d�ΰ��62�社@�ڈ�V�ᣛ�<�f� ���	�<��M8ɦTA=���uJ��h�	thQ��W��QԱa����8��SkD�nu��Bτ���@uh��B�jWyg�u�tϕ��W\�{�Y����P.U�8�E�}T�s�
�G�T^N�Y��/��|�>�0�:|�8�O^�(���6��L���!��a
q�\�zf�J
x��W�^�d�B�b]���.ȭ�po���
�˘��h�P��'�r�$�~�ۯ~+��S���?\�w�Jp�#�Ue���� }��?L-�#k�R�w)�qT���e�FeO�7+�픃�i�:�x�(��t1}�~�dwH@��y��
��5�O��كGc2�����D 9b��SQ�N����R����i�("�S���nI����!x�s&��������N<�	\#�ˏ�[���s3p5�Na��9�>x���v=(ѷ��X3�Q&�s���a���q�W?�$�%,Y	v�����(! �|�Gݏ�����&.D�eJ�M���D��*X���+�>(>�x~�:�{��s���4�e���S�3	��m/+����a���v��n��=�%���`i���i�jHI���'x�,�?ǩ�u��������Xc�!�t|	W�W?�i��O�gkA	�l�E�%����E�2/��Vx<�E����a,Ę��/d#�"���k�H�5����ъ�ğe��_�JKe�
L�6�Q���<c�>'Ў��TqI`��⽾R��C�m9?vl]��P:K�+�Q��D��/�ei��nO�l�\�ȕ>�"f"�
0�_�CgNb
m�/������o0鞵Ґ������Y�F��Pf�B�oݼ� �s��3�*N��N(�Ӵ��5���n�������Ş2{$�����g� ���P��Uû �����-�g����� t}�(6�����
�����%P�*��R';�f�u���_����Rn���Ղ�S�i��&o/�ny���=�q]�Jy�ֆ(���l��S�N�D��Eh�.��)���xE�������`c���*�&���iѻ���f���X��uvք����v��5F/edM���or���� Edp78���3�����ۊɌ�BH�\�Ѱ�o��V���Ʌ�1O�����/C�����M��w��������׾u4��:v��5��}�!ؽ�B�N��?3`�b��2��� ҷ��� �3!����Z8S�I�Ƅ9�l��	K����N���2���J���:�5�l���%�b�fX-�Zr��	m�$E�J c�Z�-$:&d*V����d�j���b�D��j�ߑl��K�3��G�Yv�CAz�
�[w)�A#.2��5�A+�Tyc:�^Z1K*�)��m�~��H�b��>����]d#Po|���*R����6�Dr$�zvS��>v���$sǢ8uW���:�e���Av�q^�����K�7�엦:!��H!7�E�7HO�/��#Ƥ�^�^*\�J�Uoh�eN%� Tj�P*��C?]M��tf���;�g[���!"���&r�